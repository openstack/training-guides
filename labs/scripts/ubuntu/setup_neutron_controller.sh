#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Networking (neutron) for controller node.
# http://docs.openstack.org/juno/install-guide/install/apt/content/neutron-controller-node.html
#------------------------------------------------------------------------------

echo "Setting up database for neutron."
setup_database neutron

source "$CONFIG_DIR/admin-openstackrc.sh"

neutron_admin_user=$(service_to_user_name neutron)
neutron_admin_password=$(service_to_user_password neutron)

echo "Creating neutron user and giving it admin role under service tenant."
keystone user-create \
    --name "$neutron_admin_user" \
    --pass "$neutron_admin_password"

keystone user-role-add \
    --user "$neutron_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Registering neutron with keystone so that other services can locate it."
keystone service-create \
    --name neutron \
    --type network \
    --description "OpenStack Networking"

neutron_service_id=$(keystone service-list | awk '/ network / {print $2}')
keystone endpoint-create \
    --service-id "$neutron_service_id" \
    --publicurl "http://controller-mgmt:9696" \
    --adminurl "http://controller-mgmt:9696" \
    --internalurl "http://controller-mgmt:9696" \
    --region "$REGION"

echo "Installing neutron for controller node."
sudo apt-get install -y neutron-server neutron-plugin-ml2 python-neutronclient

echo "Configuring neutron for controller node."

function get_database_url {
    local db_user=$(service_to_db_user neutron)
    local db_password=$(service_to_db_password neutron)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/neutron"
}

database_url=$(get_database_url)

echo "Setting database connection: $database_url."
conf=/etc/neutron/neutron.conf
iniset_sudo $conf database connection "$database_url"

# Configure AMQP parameters
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

# Configuring [DEFAULT] section
iniset_sudo $conf DEFAULT auth_strategy keystone

# Configuring [keystone_authtoken] section
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$neutron_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$neutron_admin_password"

# Configure network plugin parameters
iniset_sudo $conf DEFAULT core_plugin ml2
iniset_sudo $conf DEFAULT service_plugins router
iniset_sudo $conf DEFAULT allow_overlapping_ips True

nova_admin_user=$(service_to_user_name nova)
nova_admin_password=$(service_to_user_password nova)

service_tenant_id=$(keystone tenant-get "$SERVICE_TENANT_NAME" | awk '/ id / {print $4}')
echo "Service tenant id: $service_tenant_id"

# Configure nova related parameters
iniset_sudo $conf DEFAULT notify_nova_on_port_status_changes True
iniset_sudo $conf DEFAULT notify_nova_on_port_data_changes True
iniset_sudo $conf DEFAULT nova_url http://controller-mgmt:8774/v2
iniset_sudo $conf DEFAULT nova_admin_auth_url http://controller-mgmt:35357/v2.0
iniset_sudo $conf DEFAULT nova_region_name "$REGION"
iniset_sudo $conf DEFAULT nova_admin_username "$nova_admin_user"
iniset_sudo $conf DEFAULT nova_admin_tenant_id "$service_tenant_id"
iniset_sudo $conf DEFAULT nova_admin_password "$nova_admin_password"
iniset_sudo $conf DEFAULT verbose True

echo "Configuring the OVS plug-in to use GRE tunneling."
conf=/etc/neutron/plugins/ml2/ml2_conf.ini

# Edit the [ml2] section.
iniset_sudo $conf ml2 type_drivers flat,gre
iniset_sudo $conf ml2 tenant_network_types gre
iniset_sudo $conf ml2 mechanism_drivers openvswitch

# Edit the [ml2_type_gre] section.
iniset_sudo $conf ml2_type_gre tunnel_id_ranges 1:1000

# Edit the [securitygroup] section.
iniset_sudo $conf securitygroup enable_security_group True
iniset_sudo $conf securitygroup enable_ipset True
iniset_sudo $conf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

echo "Configure Compute to use Networking"
conf=/etc/nova/nova.conf
iniset_sudo $conf DEFAULT network_api_class nova.network.neutronv2.api.API
iniset_sudo $conf DEFAULT security_group_api neutron
iniset_sudo $conf DEFAULT linuxnet_interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
iniset_sudo $conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver

iniset_sudo $conf neutron url http://controller-mgmt:9696
iniset_sudo $conf neutron auth_strategy keystone
iniset_sudo $conf neutron admin_auth_url http://controller-mgmt:35357/v2.0
iniset_sudo $conf neutron admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf neutron admin_username "$neutron_admin_user"
iniset_sudo $conf neutron admin_password "$neutron_admin_password"

# service_neutron_metadata_proxy, neutron_metadata_proxy_shared_secret from:
# http://docs.openstack.org/juno/install-guide/install/apt/content/neutron-network-node.html
iniset_sudo $conf neutron service_metadata_proxy True
iniset_sudo $conf neutron metadata_proxy_shared_secret "$METADATA_SECRET"

sudo neutron-db-manage \
    --config-file /etc/neutron/neutron.conf \
    --config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
    upgrade juno

echo "Restart nova services"
sudo service nova-api restart
sudo service nova-scheduler restart
sudo service nova-conductor restart

echo "Restarting neutron service."
sudo service neutron-server restart

echo "Verifying operation."
until neutron ext-list >/dev/null 2>&1; do
    sleep 1
done
neutron ext-list
