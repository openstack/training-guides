#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/labs-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up Block Storage service controller (cinder controller node).
#------------------------------------------------------------------------------

echo "Installing cinder."
sudo apt-get install -y cinder-api cinder-scheduler

echo "Setting up database for cinder."
setup_database cinder

function get_database_url {
    local db_user=$(service_to_db_user cinder)
    local db_password=$(service_to_db_password cinder)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/cinder"
}

database_url=$(get_database_url)

echo "Configuring cinder."

echo "Setting database connection: $database_url."
iniset_sudo /etc/cinder/cinder.conf database connection "$database_url"

echo "Creating the database tables for cinder."
sudo cinder-manage db sync

cinder_admin_user=$(service_to_user_name cinder)
cinder_admin_password=$(service_to_user_password cinder)

echo "Creating cinder user and giving it admin role under service tenant."
keystone user-create \
    --name "$cinder_admin_user" \
    --pass "$cinder_admin_password" \
    --email cinder@domain.com

keystone user-role-add \
    --user "$cinder_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Configuring cinder to use keystone for authentication."

echo "Configuring cinder-api.conf."
conf=/etc/cinder/cinder.conf

# Configure [keystone_authtoken] section.
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000"
iniset_sudo $conf keystone_authtoken auth_host controller-mgmt
iniset_sudo $conf keystone_authtoken auth_port 35357
iniset_sudo $conf keystone_authtoken auth_protocol http
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$cinder_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$cinder_admin_password"

# Configure [DEFAULT] section.
iniset_sudo $conf DEFAULT rpc_backend cinder.openstack.common.rpc.impl_kombu
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_port 5672
iniset_sudo $conf DEFAULT rabbit_userid guest
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

echo "Registering cinder with keystone so that other services can locate it."
keystone service-create \
    --name cinder \
    --type volume \
    --description "OpenStack Block Storage"

cinder_service_id=$(keystone service-list | awk '/ volume / {print $2}')
keystone endpoint-create \
    --service-id "$cinder_service_id" \
    --publicurl "http://controller-api:8776/v1" \
    --adminurl "http://controller-mgmt:8776/v1" \
    --internalurl "http://controller-mgmt:8776/v1"

echo "Restarting cinder service."
sudo service cinder-scheduler restart
sudo service cinder-api restart
