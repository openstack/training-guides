#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up Block Storage service controller (cinder controller node)
# http://docs.openstack.org/juno/install-guide/install/apt/content/cinder-install-controller-node.html
#------------------------------------------------------------------------------

echo "Setting up database for cinder."
setup_database cinder

source "$CONFIG_DIR/admin-openstackrc.sh"

cinder_admin_user=$(service_to_user_name cinder)
cinder_admin_password=$(service_to_user_password cinder)

echo "Creating cinder user."
keystone user-create \
    --name "$cinder_admin_user" \
    --pass "$cinder_admin_password"

echo "Linking cinder user, service tenant and admin role."
keystone user-role-add \
    --user "$cinder_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Registering cinder with keystone so that other services can locate it."
keystone service-create \
    --name cinder \
    --type volume \
    --description "OpenStack Block Storage"

keystone service-create \
    --name cinderv2 \
    --type volumev2 \
    --description "OpenStack Block Storage v2"

cinder_service_id=$(keystone service-list | awk '/ volume / {print $2}')
keystone endpoint-create \
    --service-id "$cinder_service_id" \
    --publicurl 'http://controller-api:8776/v1/%(tenant_id)s' \
    --adminurl 'http://controller-mgmt:8776/v1/%(tenant_id)s' \
    --internalurl 'http://controller-mgmt:8776/v1/%(tenant_id)s'

cinder_v2_service_id=$(keystone service-list | awk '/ volumev2 / {print $2}')
keystone endpoint-create \
    --service-id "$cinder_v2_service_id" \
    --publicurl 'http://controller-api:8776/v2/%(tenant_id)s' \
    --adminurl 'http://controller-mgmt:8776/v2/%(tenant_id)s' \
    --internalurl 'http://controller-mgmt:8776/v2/%(tenant_id)s'

echo "Installing cinder."
sudo apt-get install -y cinder-api cinder-scheduler python-cinderclient \
    qemu-utils
# Note: The package 'qemu-utils' is required for 'qemu-img' which allows cinder
#       to convert additional image types to bootable volumes. By default only
#       raw images can be converted.

function get_database_url {
    local db_user=$(service_to_db_user cinder)
    local db_password=$(service_to_db_password cinder)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/cinder"
}

database_url=$(get_database_url)

echo "Configuring cinder-api.conf."
conf=/etc/cinder/cinder.conf

echo "Setting database connection: $database_url."
iniset_sudo $conf database connection "$database_url"

# Configure [DEFAULT] section to use RabbitMQ message broker.
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"
iniset_sudo $conf DEFAULT auth_strategy keystone

# Configure [keystone_authtoken] section.
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$cinder_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$cinder_admin_password"

iniset_sudo $conf DEFAULT my_ip "$(hostname_to_ip controller-mgmt)"

iniset_sudo $conf DEFAULT verbose True

echo "Creating the database tables for cinder."
sudo cinder-manage db sync

echo "Restarting cinder service."
sudo service cinder-scheduler restart
sudo service cinder-api restart

echo "Removing unused SQLite database file (if any)."
sudo rm -rf /var/lib/cinder/cinder.sqlite
