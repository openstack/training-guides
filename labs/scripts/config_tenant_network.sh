#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Create tenant network
# http://docs.openstack.org/juno/install-guide/install/apt/content/neutron_initial-tenant-network.html
#------------------------------------------------------------------------------

echo "Sourcing the demo credentials."
source "$CONFIG_DIR/demo-openstackrc.sh"

echo "Waiting for neutron to start."
until neutron net-list >/dev/null 2>&1; do
    sleep 1
done

echo "Creating the tenant network."
neutron net-create demo-net

echo "Creating a subnet on the tenant network."
neutron subnet-create demo-net \
    --name demo-subnet \
    --gateway "$TENANT_NETWORK_GATEWAY" \
    "$TENANT_NETWORK_CIDR"

echo "Creating a router on the tenant network."
neutron router-create demo-router

echo "Attaching the router to the demo tenant subnet."
neutron router-interface-add demo-router demo-subnet

echo "Attaching the router to the external network by setting it as the" \
    "gateway."
neutron router-gateway-set demo-router ext-net
