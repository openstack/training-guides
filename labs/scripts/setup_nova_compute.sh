#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/admin-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Compute (nova) for compute node.
#------------------------------------------------------------------------------

echo "Installing nova for compute node."
sudo apt-get install -y nova-compute-qemu


# Remove SQLite database created by Ubuntu package for nova.
sudo rm -v /var/lib/nova/nova.sqlite

function get_database_url {
    local db_user=$(service_to_db_user nova)
    local db_password=$(service_to_db_password nova)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/nova"
}

database_url=$(get_database_url)

echo "Configuring nova for compute node."

echo "Setting database connection: $database_url."
iniset_sudo /etc/nova/nova.conf database connection "$database_url"

nova_admin_user=$(service_to_user_name nova)
nova_admin_password=$(service_to_user_password nova)

conf=/etc/nova/nova.conf
echo "Configuring $conf."
# Configuring [DEFAULT] section

# Configure RabbitMQ variables
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

# Configure other variables
iniset_sudo $conf DEFAULT my_ip "$(hostname_to_ip compute-mgmt)"
iniset_sudo $conf DEFAULT vncserver_listen 0.0.0.0
iniset_sudo $conf DEFAULT vnc_enabled True
iniset_sudo $conf DEFAULT vncserver_proxyclient_address compute-mgmt
iniset_sudo $conf DEFAULT novncproxy_base_url http://"$(hostname_to_ip controller-api)":6080/vnc_auto.html
iniset_sudo $conf DEFAULT glance_host controller-mgmt
iniset_sudo $conf DEFAULT auth_strategy keystone

# Configure [keystone_authtoken] section
iniset_sudo $conf keystone_authtoken auth_uri http://controller-mgmt:5000
iniset_sudo $conf keystone_authtoken auth_host controller-mgmt
iniset_sudo $conf keystone_authtoken auth_port 35357
iniset_sudo $conf keystone_authtoken auth_protocol http
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$nova_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$nova_admin_password"

# Configure nova-comptue.conf
conf=/etc/nova/nova-compute.conf
iniset_sudo $conf libvirt virt_type qemu

echo "Restarting nova services."
sudo service nova-compute restart

#------------------------------------------------------------------------------
# Verify the Nova installation on Compute Node
#------------------------------------------------------------------------------

echo "Verifying nova output."

echo "Verify nova service status."
# This call needs root privileges for read access to /etc/nova/nova.conf.
echo "sudo nova-manage service list"
sudo nova-manage service list
