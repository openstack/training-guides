#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/admin-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Compute (nova) for controller node.
#------------------------------------------------------------------------------

echo "Installing nova for controller node."
sudo apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth \
                        nova-novncproxy nova-scheduler python-novaclient

# Remove SQLite database created by Ubuntu package for nova.
sudo rm -v /var/lib/nova/nova.sqlite

echo "Setting up database for nova."
setup_database nova

function get_database_url {
    local db_user=$(service_to_db_user nova)
    local db_password=$(service_to_db_password nova)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/nova"
}

database_url=$(get_database_url)

echo "Configuring nova for controller node."

echo "Setting database connection: $database_url."
iniset_sudo /etc/nova/nova.conf database connection "$database_url"

nova_admin_user=$(service_to_user_name nova)
nova_admin_password=$(service_to_user_password nova)

echo "Creating nova user and giving it admin role under service tenant."
keystone user-create \
    --name "$nova_admin_user" \
    --pass "$nova_admin_password" \
    --email "nova@$MAIL_DOMAIN"

keystone user-role-add \
    --user "$nova_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Configuring nova to use keystone for authentication."
echo "Configuring nova.conf"
conf=/etc/nova/nova.conf
# Configuring [DEFAULT] section

# Configure RabbitMQ variables
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

# Configure other variables
iniset_sudo $conf DEFAULT my_ip "$(hostname_to_ip controller-mgmt)"
iniset_sudo $conf DEFAULT vncserver_listen controller-mgmt
iniset_sudo $conf DEFAULT vncserver_proxyclient_address controller-mgmt
iniset_sudo $conf DEFAULT auth_strategy keystone

# Configure [keystone_authtoken] section
iniset_sudo $conf keystone_authtoken auth_uri http://controller-mgmt:5000
iniset_sudo $conf keystone_authtoken auth_host controller-mgmt
iniset_sudo $conf keystone_authtoken auth_port 35357
iniset_sudo $conf keystone_authtoken auth_protocol http
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$nova_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$nova_admin_password"


echo "Registering nova with keystone so that other services can locate it."
keystone service-create \
    --name nova \
    --type compute \
    --description "OpenStack Compute"

nova_service_id=$(keystone service-list | awk '/ compute / {print $2}')
keystone endpoint-create \
    --service-id "$nova_service_id" \
    --publicurl 'http://controller-api:8774/v2/%(tenant_id)s' \
    --adminurl 'http://controller-mgmt:8774/v2/%(tenant_id)s' \
    --internalurl 'http://controller-mgmt:8774/v2/%(tenant_id)s'

echo "Creating the database tables for nova."
sudo nova-manage db sync

echo "Restarting nova services."
declare -a components=(nova-api nova-cert nova-consoleauth nova-scheduler
                        nova-conductor nova-novncproxy)
for component in "${components[@]}"; do
    echo "Restarting $component"
    sudo service "$component" restart
done

#------------------------------------------------------------------------------
# Verify the Compute controller installation
#------------------------------------------------------------------------------

echo "Verifying nova output."

echo "Verify nova service status."
# This call needs root privileges for read access to /etc/nova/nova.conf.
echo "sudo nova-manage service list"
sudo nova-manage service list

echo "nova image-list"
nova image-list

echo "nova list-extensions"
nova list-extensions
