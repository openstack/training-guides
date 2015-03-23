#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/admin-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Networking (neutron) for compute node.
# http://docs.openstack.org/juno/install-guide/install/apt/content/neutron-compute-node.html
#------------------------------------------------------------------------------

echo "Editing /etc/sysctl.conf: disable Reverse Path Forwarding filter."
cat << SYSCTL | sudo tee -a /etc/sysctl.conf
# Disable Reverse Path Forwarding filter (RFC 3704)
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
SYSCTL

# Reload changed file
sudo sysctl -p

echo "Installing networking components for compute node."
sudo apt-get install -y neutron-plugin-ml2 \
    neutron-plugin-openvswitch-agent

echo "Configuring neutron for compute node."

neutron_admin_user=$(service_to_user_name neutron)
neutron_admin_password=$(service_to_user_password neutron)

conf=/etc/neutron/neutron.conf
echo "Configuring $conf."

# Configure AMQP parameters
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

# Configuring [DEFAULT] section
iniset_sudo $conf DEFAULT auth_strategy keystone

# Configuring [keystone_authtoken] section
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri http://controller-mgmt:35357
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$neutron_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$neutron_admin_password"

# Configure network plugin parameters
iniset_sudo $conf DEFAULT core_plugin ml2
iniset_sudo $conf DEFAULT service_plugins router
iniset_sudo $conf DEFAULT allow_overlapping_ips True

iniset_sudo $conf DEFAULT verbose True

echo "Configuring the OVS plug-in to use GRE tunneling."
conf=/etc/neutron/plugins/ml2/ml2_conf.ini

# Under the ml2 section
iniset_sudo $conf ml2 type_drivers flat,gre
iniset_sudo $conf ml2 tenant_network_types gre
iniset_sudo $conf ml2 mechanism_drivers openvswitch

# Under the ml2_type_gre section
iniset_sudo $conf ml2_type_gre tunnel_id_ranges 1:1000

# Under the securitygroup section
iniset_sudo $conf securitygroup enable_security_group True
iniset_sudo $conf securitygroup enable_ipset True
iniset_sudo $conf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

# Under the ovs section
iniset_sudo $conf ovs local_ip "$(hostname_to_ip compute-data)"
iniset_sudo $conf ovs enable_tunneling True

iniset_sudo $conf agent tunnel_types gre

echo "Restarting the Open vSwitch (OVS) service."
sudo service openvswitch-switch restart

echo "Configuring Compute to use Networking."
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

echo "Restarting the Compute service."
sudo service nova-compute restart

echo "Restarting the OVS agent."
sudo service neutron-plugin-openvswitch-agent restart
