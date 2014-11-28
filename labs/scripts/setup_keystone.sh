#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up keystone for controller node
#------------------------------------------------------------------------------

echo "Installing keystone."
sudo apt-get install -y keystone

echo "Removing default SQLite database."
sudo rm -f /var/lib/keystone/keystone.db

echo "Setting up database for keystone."
setup_database keystone

function get_database_url {
    local db_user=$(service_to_db_user keystone)
    local db_password=$(service_to_db_password keystone)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/keystone"
}

database_url=$(get_database_url)

echo "Configuring /etc/keystone/keystone.conf."

echo "Setting database connection: $database_url."
iniset_sudo /etc/keystone/keystone.conf database connection "$database_url"

echo "Setting admin_token to bootstrap authentication."
iniset_sudo /etc/keystone/keystone.conf DEFAULT admin_token "$ADMIN_TOKEN"

echo "Setting log directory to /var/log/keystone."
iniset_sudo /etc/keystone/keystone.conf DEFAULT log_dir "/var/log/keystone"

sudo service keystone restart

echo "Creating the database tables for keystone."
sudo keystone-manage db_sync

#------------------------------------------------------------------------------
# Configure keystone users, roles, and endpoints so it can be used for
# authentication.
#------------------------------------------------------------------------------

echo "Using OS_SERVICE_TOKEN, OS_SERVICE_ENDPOINT for authentication."
export OS_SERVICE_TOKEN=$ADMIN_TOKEN
export OS_SERVICE_ENDPOINT="http://controller-mgmt:35357/v2.0"

echo "Adding admin tenant."
keystone tenant-create --name "$ADMIN_TENANT_NAME" --description "Admin Tenant"

echo "Creating admin user."
keystone user-create --name "$ADMIN_USER_NAME" --pass "$ADMIN_PASSWORD" --email "admin@$MAIL_DOMAIN"

echo "Creating admin roles."
keystone role-create --name "$ADMIN_ROLE_NAME"

echo "Adding admin roles to admin user."
keystone user-role-add \
    --tenant "$ADMIN_TENANT_NAME" \
    --user "$ADMIN_USER_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Creating keystone service."
keystone service-create \
    --name keystone \
    --type identity \
    --description 'OpenStack Identity'

echo "Creating endpoints for keystone."
keystone_service_id=$(keystone service-list | awk '/ keystone / {print $2}')
keystone endpoint-create \
    --service-id "$keystone_service_id" \
    --publicurl "http://controller-api:5000/v2.0" \
    --adminurl "http://controller-mgmt:35357/v2.0" \
    --internalurl "http://controller-mgmt:5000/v2.0"

echo "Creating demo user."
keystone user-create --name "$DEMO_USER_NAME" --pass "$DEMO_PASSWORD" --email "demo@$MAIL_DOMAIN"

echo "Creating demo tenant."
keystone tenant-create --name "$DEMO_TENANT_NAME" --description "Demo Tenant"

echo "Linking the demo user, _member_ role, and demo tenant."
keystone user-role-add \
    --tenant "$DEMO_TENANT_NAME" \
    --user "$DEMO_USER_NAME" \
    --role "$MEMBER_ROLE_NAME"

echo "Adding service tenant."
keystone tenant-create \
    --name "$SERVICE_TENANT_NAME" \
    --description "Service Tenant"

#------------------------------------------------------------------------------
# Verify the Identity Service installation
#------------------------------------------------------------------------------

echo "Verifying keystone installation."

# From this point on, we are going to use keystone for authentication
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT

# Load keystone credentials
source "$CONFIG_DIR/admin-openstackrc.sh"

# The output of the following commands can be used to verify or debug the
# service.

echo "keystone token-get"
keystone token-get

echo "keystone user-list"
keystone user-list

echo "keystone user-role-list --user $ADMIN_USER_NAME --tenant $ADMIN_TENANT_NAME"
keystone user-role-list --user "$ADMIN_USER_NAME" --tenant "$ADMIN_TENANT_NAME"
