#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Networking (neutron) for network node.
#------------------------------------------------------------------------------

echo "Disabling Reverse Path Forwarding filter (RFC 3704)."
sudo sysctl -w "net.ipv4.conf.all.rp_filter=0"
sudo sysctl -w "net.ipv4.conf.default.rp_filter=0"
sudo sysctl -w "net.ipv4.ip_forward=1"

echo "Installing neutron for network node."
sudo apt-get install -y neutron-common neutron-plugin-ml2 \
    neutron-plugin-openvswitch-agent neutron-l3-agent \
    neutron-dhcp-agent

echo "Configuring neutron for network node."

neutron_admin_user=$(service_to_user_name neutron)
neutron_admin_password=$(service_to_user_password neutron)

echo "Configuring neutron to use keystone for authentication."
conf=/etc/neutron/neutron.conf
echo "Configuring $conf."

# Configuring [DEFAULT] section
iniset_sudo $conf DEFAULT auth_strategy keystone
iniset_sudo $conf DEFAULT verbose True

# Configure AMQP parameters
iniset_sudo $conf DEFAULT rpc_backend neutron.openstack.common.rpc.impl_kombu
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

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

echo "Configuring the OVS plug-in to use GRE tunneling."
conf=/etc/neutron/plugins/ml2/ml2_conf.ini

# Under the ml2 section
iniset_sudo $conf ml2 type_drivers gre
iniset_sudo $conf ml2 tenant_network_types gre
iniset_sudo $conf ml2 mechanism_drivers openvswitch

# Under the ml2_type_gre section
iniset_sudo $conf ml2_type_gre tunnel_id_ranges 1:1000

# Under the securitygroup section
iniset_sudo $conf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
iniset_sudo $conf securitygroup enable_security_group True

# Under the ovs section
iniset_sudo $conf ovs local_ip "$(hostname_to_ip network-data)"
iniset_sudo $conf ovs tunnel_type gre
iniset_sudo $conf ovs enable_tunneling True

echo "Restarting the Open vSwitch (OVS) service."
sudo service openvswitch-switch restart

echo "Adding the integration bridge."
sudo ovs-vsctl --may-exist add-br br-int

echo "Adding the external bridge"
sudo ovs-vsctl add-br br-ex

echo "Adding port to external bridge."
sudo ovs-vsctl add-port br-ex eth3

echo "Configuring Layer-3 agent."
conf=/etc/neutron/l3_agent.ini
iniset_sudo $conf DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
iniset_sudo $conf DEFAULT use_namespaces True
iniset_sudo $conf DEFAULT verbose True

echo "Configuring the metadata agent"
conf=/etc/neutron/metadata_agent.ini
iniset_sudo $conf DEFAULT auth_uri http://controller-mgmt:5000/v2.0
iniset_sudo $conf DEFAULT auth_region regionOne
iniset_sudo $conf DEFAULT admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf DEFAULT admin_user "$neutron_admin_user"
iniset_sudo $conf DEFAULT admin_password "$neutron_admin_password"
iniset_sudo $conf DEFAULT nova_metadata_ip controller-mgmt
iniset_sudo $conf DEFAULT metadata_proxy_shared_secret "$METADATA_SECRET"

echo "Configuring the DHCP agent"
conf=/etc/neutron/dhcp_agent.ini
iniset_sudo $conf DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
iniset_sudo $conf DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
iniset_sudo $conf DEFAULT use_namespaces True
iniset_sudo $conf DEFAULT verbose True

echo "Restarting the network service."
sudo service neutron-plugin-openvswitch-agent restart
sudo service neutron-l3-agent restart
sudo service neutron-dhcp-agent restart
sudo service neutron-metadata-agent restart

echo "Restarting the OVS agent."
sudo service neutron-plugin-openvswitch-agent restart
