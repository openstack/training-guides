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
# Set up OpenStack neutron LBaaS for network node.
# http://docs.openstack.org/admin-guide-cloud/content/install_neutron-lbaas-agent.html
#------------------------------------------------------------------------------

echo "Installing neutron lbaas agent for network node."
sudo apt-get install -y neutron-lbaas-agent

echo "Configuring LBaaS agent for network node."
conf=/etc/neutron/lbaas_agent.ini
iniset_sudo $conf DEFAULT device_driver neutron.services.loadbalancer.drivers.haproxy.namespace_driver.HaproxyNSDriver
iniset_sudo $conf DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver

echo "Restarting the neutron lbaas agent service."
sudo service neutron-lbaas-agent restart

#------------------------------------------------------------------------------
# Verify the neutron LBaaS installation
#------------------------------------------------------------------------------

echo "Verifying neutron lbaas installation."

echo "Waiting for neutron-lbaas-agent to start."
AUTH="source $CONFIG_DIR/demo-openstackrc.sh"
until node_ssh controller-mgmt "$AUTH; neutron lb-pool-list" >/dev/null 2>&1; do
    sleep 1
done

LB_NUMBER=$(date +"%d%m%y%H%M%S")
echo "neutron lb-pool-create --lb-method ROUND_ROBIN --name test-lb$LB_NUMBER --protocol HTTP --subnet-id demo-subnet"
node_ssh controller-mgmt "$AUTH; neutron lb-pool-create --lb-method ROUND_ROBIN --name test-lb$LB_NUMBER --protocol HTTP --subnet-id demo-subnet"

echo "Checking if created pool is active."
until node_ssh controller-mgmt "$AUTH; neutron lb-pool-list | grep test-lb$LB_NUMBER | grep -i ACTIVE" > /dev/null 2>&1; do
    sleep 1
done
echo "Success."

echo "neutron lb-pool-list"
node_ssh controller-mgmt "$AUTH; neutron lb-pool-list"

echo "neutron lb-pool-delete test-lb$LB_NUMBER"
node_ssh controller-mgmt "$AUTH; neutron lb-pool-delete test-lb$LB_NUMBER"

echo "neutron lb-pool-list"
node_ssh controller-mgmt "$AUTH; neutron lb-pool-list"
