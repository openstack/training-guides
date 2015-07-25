#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/openstack"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Networking (neutron) for network node.
# http://docs.openstack.org/juno/install-guide/install/apt/content/neutron-network-node.html
#------------------------------------------------------------------------------

echo "Editing /etc/sysctl.conf: enable IP forwarding, disable RPF filter."
cat << SYSCTL | sudo tee -a /etc/sysctl.conf
# Enable IP forwarding
net.ipv4.ip_forward=1
# Disable Reverse Path Forwarding filter (RFC 3704)
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
SYSCTL

# Reload changed file
sudo sysctl -p

echo "Installing networking components for network node."
sudo apt-get install -y neutron-plugin-ml2 neutron-plugin-openvswitch-agent \
    neutron-l3-agent neutron-dhcp-agent

# neutron-l3-agent has just been installed and is about to start. We are also
# about to change its configuration file which tends to result in the agent
# starting up with our changed configuration before the external bridge is
# ready which ends with a misconfigured system (port with tag=4095). We can
# either wait here for neutron-l3-agent to start with the old configuration
# files, or shut it down now and start it with the new configuration files once
# configuration files _and_ the external bridge are ready.
echo "Stopping neutron-l3-agent for now."
sudo service neutron-l3-agent stop

echo "Configuring neutron for network node."

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
iniset_sudo $conf keystone_authtoken auth_uri http://controller-mgmt:5000/v2.0
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

iniset_sudo $conf ml2_type_flat flat_networks external

# Under the ml2_type_gre section
iniset_sudo $conf ml2_type_gre tunnel_id_ranges 1:1000

# Under the securitygroup section
iniset_sudo $conf securitygroup enable_security_group True
iniset_sudo $conf securitygroup enable_ipset True
iniset_sudo $conf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

# Under the ovs section
iniset_sudo $conf ovs local_ip "$(hostname_to_ip network-data)"
iniset_sudo $conf ovs enable_tunneling True
iniset_sudo $conf ovs bridge_mappings external:br-ex

iniset_sudo $conf agent tunnel_types gre

echo "Configuring Layer-3 agent."
conf=/etc/neutron/l3_agent.ini
iniset_sudo $conf DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
iniset_sudo $conf DEFAULT use_namespaces True
iniset_sudo $conf DEFAULT external_network_bridge br-ex
iniset_sudo $conf DEFAULT router_delete_namespaces True
iniset_sudo $conf DEFAULT verbose True

echo "Configuring the DHCP agent"
conf=/etc/neutron/dhcp_agent.ini
iniset_sudo $conf DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
iniset_sudo $conf DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
iniset_sudo $conf DEFAULT use_namespaces True
iniset_sudo $conf DEFAULT dhcp_delete_namespaces True
iniset_sudo $conf DEFAULT verbose True
iniset_sudo $conf DEFAULT dnsmasq_config_file /etc/neutron/dnsmasq-neutron.conf

# Configure a DNS server to be used by VM instances
if [ -n "${TENANT_VM_DNS_SERVER:-''}" ]; then
    iniset_sudo $conf DEFAULT dnsmasq_dns_servers "$TENANT_VM_DNS_SERVER"
fi

cat << DNSMASQ | sudo tee /etc/neutron/dnsmasq-neutron.conf
# Set interface MTU to 1454 (for instance, ssh authentication may fail
# otherwise due to GRE overhead)
dhcp-option-force=26,1454

# Override --no-hosts dnsmasq option supplied by neutron
addn-hosts=/etc/hosts

# Log dnsmasq queries to syslog
log-queries

# Verbose logging for DHCP
log-dhcp
DNSMASQ

# Catch and ignore error status if no dnsmasq process is found (the default)
sudo killall dnsmasq||rc=$?

echo "Configuring the metadata agent"
conf=/etc/neutron/metadata_agent.ini
iniset_sudo $conf DEFAULT auth_url http://controller-mgmt:5000/v2.0
iniset_sudo $conf DEFAULT auth_region "$REGION"
iniset_sudo $conf DEFAULT admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf DEFAULT admin_user "$neutron_admin_user"
iniset_sudo $conf DEFAULT admin_password "$neutron_admin_password"
iniset_sudo $conf DEFAULT nova_metadata_ip "$(hostname_to_ip controller-mgmt)"
iniset_sudo $conf DEFAULT metadata_proxy_shared_secret "$METADATA_SECRET"
iniset_sudo $conf DEFAULT verbose True

# The next two steps according to the install-guide (configuring
# service_metadata_proxy and metadata_proxy_shared_secret) have already been
# done in setup_neutron_controller.sh.

# XXX The install-guide wants us to restart nova-api on controller now, but we
#     ignore that for now; by default, the controller gets rebooted for a
#     snapshot anyway.

echo "Restarting the Open vSwitch (OVS) service."
sudo service openvswitch-switch restart

echo "Adding the external bridge"
sudo ovs-vsctl add-br br-ex

echo "Adding port to external bridge."
sudo ovs-vsctl add-port br-ex eth3

network_api_ip=$(hostname_to_ip network-api)

echo "Moving network-api IP address from eth3 to a switch-internal device."
sudo ifconfig eth3 0.0.0.0
sudo ifconfig br-ex "$network_api_ip"

echo "Making the IP address move reboot-safe."
sudo sed -i "s/$network_api_ip/0.0.0.0/" /etc/network/interfaces
cat << INTERFACES | sudo tee -a /etc/network/interfaces

auto br-ex
iface br-ex inet static
      address $network_api_ip
      netmask 255.255.255.0
INTERFACES

# Check if we can get to the API network again
ping -c 1 controller-api

echo "Restarting the network service."
sudo service neutron-plugin-openvswitch-agent restart
sudo service neutron-l3-agent restart

echo -n "Checking VLAN tags."
# Wait for "tag:" to show up
until sudo ovs-vsctl show|grep tag:; do
    echo -n "."
    sleep 1
done
if sudo ovs-vsctl show|grep "tag: 4095"; then
    # tag: 4095 indicates an error
    echo >&2 "ERROR: port is in limbo and won't recover:"
    grep tag=4095 /etc/openvswitch/conf.db >&2
    exit 1
fi

echo -n "Getting router namespace."
until ip netns|grep qrouter; do
    echo -n "."
    sleep 1
done
nsrouter=$(ip netns|grep qrouter)

sudo service neutron-dhcp-agent restart

echo -n "Getting DHCP namespace."
until ip netns|grep qdhcp; do
    echo -n "."
    sleep 1
done
nsdhcp=$(ip netns|grep qdhcp)

echo -n "Waiting for interface qr-* in router namespace."
until sudo ip netns exec "$nsrouter" ip addr|grep -Po "(?<=: )qr-.*(?=:)"; do
    echo -n "."
    sleep 1
done

echo -n "Waiting for interface qg-* in router namespace."
until sudo ip netns exec "$nsrouter" ip addr|grep -Po "(?<=: )qg-.*(?=:)"; do
    echo -n "."
    sleep 1
done

echo -n "Waiting for interface tap* in DHCP namespace."
until sudo ip netns exec "$nsdhcp" ip addr|grep -Po "(?<=: )tap.*(?=:)"; do
    echo -n "."
    sleep 1
done

sudo service neutron-metadata-agent restart

#------------------------------------------------------------------------------
# Verify the Networking Service installation
#------------------------------------------------------------------------------

echo "Verifying neutron installation."

# Load keystone credentials
source "$CONFIG_DIR/admin-openstackrc.sh"

echo "neutron agent-list"
neutron agent-list
