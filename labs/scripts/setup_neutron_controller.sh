#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/labs-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Networking (neutron) for controller node.
#------------------------------------------------------------------------------

echo "Installing neutron for controller node."
sudo apt-get install -y neutron-server neutron-plugin-ml2

echo "Setting up database for neutron."
setup_database neutron

function get_database_url {
    local db_user=$(service_to_db_user neutron)
    local db_password=$(service_to_db_password neutron)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/neutron"
}

database_url=$(get_database_url)

echo "Configuring neutron for controller node."

echo "Setting database connection: $database_url."
iniset_sudo /etc/neutron/neutron.conf database connection "$database_url"

neutron_admin_user=$(service_to_user_name neutron)
neutron_admin_password=$(service_to_user_password neutron)
nova_admin_user=$(service_to_user_name nova)
nova_admin_password=$(service_to_user_password nova)

echo "Creating neutron user and giving it admin role under service tenant."
keystone user-create \
    --name "$neutron_admin_user" \
    --pass "$neutron_admin_password" \
    --email neutron@domain.com

keystone user-role-add \
    --user "$neutron_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Configuring neutron to use keystone for authentication."
echo "Configuring neutron.conf"
conf=/etc/neutron/neutron.conf
service_tenant_id=$(keystone tenant-get "$SERVICE_TENANT_NAME" | awk '/ id / {print $4}')
echo "Service tenant id: $service_tenant_id"

# Configuring [DEFAULT] section
iniset_sudo $conf DEFAULT auth_strategy keystone

# Configure AMQP parameters
iniset_sudo $conf DEFAULT rpc_backend neutron.openstack.common.rpc.impl_kombu
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password $RABBIT_PASSWORD
iniset_sudo $conf DEFAULT notify_nova_on_port_status_changes True
iniset_sudo $conf DEFAULT notify_nova_on_port_data_changes True

# Configure nova related parameters
iniset_sudo $conf DEFAULT nova_url http://controller-mgmt:8774/v2
iniset_sudo $conf DEFAULT nova_admin_username $nova_admin_user
iniset_sudo $conf DEFAULT nova_admin_tenant_id $service_tenant_id
iniset_sudo $conf DEFAULT nova_admin_password $nova_admin_password
iniset_sudo $conf DEFAULT nova_admin_auth_url http://controller-mgmt:35357/v2.0

# Configure network plugin parameters
iniset_sudo $conf DEFAULT core_plugin ml2
iniset_sudo $conf DEFAULT service_plugins router
iniset_sudo $conf DEFAULT allow_overlapping_ips True

# Configuring [keystone_authtoken] section
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000"
iniset_sudo $conf keystone_authtoken auth_host controller-mgmt
iniset_sudo $conf keystone_authtoken auth_port 35357
iniset_sudo $conf keystone_authtoken auth_protocol http
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$neutron_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$neutron_admin_password"

echo "Registering neutron with keystone so that other services can locate it."
keystone service-create \
    --name neutron \
    --type network \
    --description "OpenStack Networking"

neutron_service_id=$(keystone service-list | awk '/ network / {print $2}')
keystone endpoint-create \
    --service-id "$neutron_service_id" \
    --publicurl "http://controller-api:9696" \
    --adminurl "http://controller-mgmt:9696" \
    --internalurl "http://controller-mgmt:9696"

echo "Configuring the OVS plug-in to use GRE tunneling."
conf=/etc/neutron/plugins/ml2/ml2_conf.ini
iniset_sudo $conf ml2 type_drivers gre
iniset_sudo $conf ml2 tenant_network_types gre
iniset_sudo $conf ml2 mechanism_drivers openvswitch
iniset_sudo $conf ml2_type_gre tunnel_id_ranges 1:1000
iniset_sudo $conf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
iniset_sudo $conf securitygroup enable_security_group True

echo "Configure Compute to use Networking"
conf=/etc/nova/nova.conf
iniset_sudo $conf DEFAULT network_api_class nova.network.neutronv2.api.API
iniset_sudo $conf DEFAULT neutron_url http://controller-mgmt:9696
iniset_sudo $conf DEFAULT neutron_auth_strategy keystone
iniset_sudo $conf DEFAULT neutron_admin_tenant_name service
iniset_sudo $conf DEFAULT neutron_admin_username neutron
iniset_sudo $conf DEFAULT neutron_admin_password NEUTRON_PASS
iniset_sudo $conf DEFAULT neutron_admin_auth_url http://controller-mgmt:35357/v2.0
iniset_sudo $conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
iniset_sudo $conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
iniset_sudo $conf DEFAULT security_group_api neutron

echo "Restart nova services"
sudo service nova-api restart
sudo service nova-scheduler restart
sudo service nova-conductor restart

echo "Restarting neutron service."
sudo service neutron-server restart

