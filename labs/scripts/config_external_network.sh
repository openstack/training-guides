#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Create the external network and a subnet on it
# http://docs.openstack.org/juno/install-guide/install/apt/content/neutron_initial-external-network.html
#------------------------------------------------------------------------------

echo "Sourcing the admin credentials."
source "$CONFIG_DIR/admin-openstackrc.sh"

echo "Waiting for neutron to start."
until neutron net-list >/dev/null 2>&1; do
    sleep 1
done

echo "Creating the external network."
neutron net-create ext-net \
    --router:external True \
    --provider:physical_network external \
    --provider:network_type flat

echo "Creating a subnet on the external network."
neutron subnet-create ext-net \
    --name ext-subnet \
    --allocation-pool start="$FLOATING_IP_START,end=$FLOATING_IP_END" \
    --disable-dhcp \
    --gateway "$EXTERNAL_NETWORK_GATEWAY" \
    "$EXTERNAL_NETWORK_CIDR"
