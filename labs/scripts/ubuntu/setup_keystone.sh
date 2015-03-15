#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
# Get REGION
source "$CONFIG_DIR/openstack"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up keystone for controller node
# http://docs.openstack.org/juno/install-guide/install/apt/content/keystone-install.html
#------------------------------------------------------------------------------

echo "Setting up database for keystone."
setup_database keystone

# Create a "shared secret" used as OS_SERVICE_TOKEN, together with
# OS_SERVICE_ENDPOINT, before keystone can be used for authentication
echo -n "Using openssl to generate a random admin token: "
ADMIN_TOKEN=$(openssl rand -hex 10)
echo "$ADMIN_TOKEN"

echo "Installing keystone."
sudo apt-get install -y keystone python-keystoneclient

conf=/etc/keystone/keystone.conf
echo "Configuring [DEFAULT] section in $conf."

echo "Setting admin_token to bootstrap authentication."
iniset_sudo $conf DEFAULT admin_token "$ADMIN_TOKEN"

function get_database_url {
    local db_user=$(service_to_db_user keystone)
    local db_password=$(service_to_db_password keystone)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/keystone"
}

database_url=$(get_database_url)

echo "Configuring [database] section in /etc/keystone/keystone.conf."

echo "Setting database connection: $database_url."
iniset_sudo $conf database connection "$database_url"

echo "Configuring the UUID token provider and SQL driver."
iniset_sudo $conf token provider keystone.token.providers.uuid.Provider
iniset_sudo $conf token driver keystone.token.persistence.backends.sql.Token

echo "Enabling verbose logging."
iniset_sudo $conf DEFAULT verbose True

echo "Creating the database tables for keystone."
sudo keystone-manage db_sync

echo "Restarting keystone."
sudo service keystone restart

echo "Removing default SQLite database."
sudo rm -f /var/lib/keystone/keystone.db

if ! sudo crontab -l -u keystone 2>&1 | grep token_flush; then
    # No existing crontab entry for token_flush -- add one now.
    echo "Adding crontab entry to purge expired tokens:"
    cat << CRON | sudo tee -a /var/spool/cron/crontabs/keystone
# Purges expired tokens every hour and logs the output
@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1
CRON
    echo "---------------------------------------------"
fi

#------------------------------------------------------------------------------
# Configure keystone users, tenants and roles
# http://docs.openstack.org/juno/install-guide/install/apt/content/keystone-users.html
#------------------------------------------------------------------------------

echo "Using OS_SERVICE_TOKEN, OS_SERVICE_ENDPOINT for authentication."
export OS_SERVICE_TOKEN=$ADMIN_TOKEN
export OS_SERVICE_ENDPOINT="http://controller-mgmt:35357/v2.0"

# Wait for keystone to come up
until keystone user-list >/dev/null 2>&1; do
    sleep 1
done

echo "Adding admin tenant."
keystone tenant-create --name "$ADMIN_TENANT_NAME" --description "Admin Tenant"

echo "Creating admin user."
keystone user-create \
    --name "$ADMIN_USER_NAME" \
    --pass "$ADMIN_PASSWORD" \
    --email "admin@$MAIL_DOMAIN"

echo "Creating admin role."
keystone role-create --name "$ADMIN_ROLE_NAME"

echo "Linking admin user, admin role and admin tenant."
keystone user-role-add \
    --user "$ADMIN_USER_NAME" \
    --tenant "$ADMIN_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Creating demo tenant."
keystone tenant-create --name "$DEMO_TENANT_NAME" --description "Demo Tenant"

echo "Creating demo user."
# Using the --tenant option automatically assigns the _member_ role to a user.
# This option will also create the _member_ role if it does not exist.
keystone user-create \
    --name "$DEMO_USER_NAME" \
    --tenant "$DEMO_TENANT_NAME" \
    --pass "$DEMO_PASSWORD" \
    --email "demo@$MAIL_DOMAIN"

echo "Adding service tenant."
keystone tenant-create \
    --name "$SERVICE_TENANT_NAME" \
    --description "Service Tenant"

#------------------------------------------------------------------------------
# Configure keystone services and API endpoints
# http://docs.openstack.org/juno/install-guide/install/apt/content/keystone-services.html
#------------------------------------------------------------------------------

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
    --internalurl "http://controller-mgmt:5000/v2.0" \
    --adminurl "http://controller-mgmt:35357/v2.0" \
    --region "$REGION"

#------------------------------------------------------------------------------
# Verify the Identity Service installation
# http://docs.openstack.org/icehouse/install-guide/install/apt/content/keystone-verify.html
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
