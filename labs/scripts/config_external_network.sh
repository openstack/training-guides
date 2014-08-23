#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/admin-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Create the external network and a subnet on it.
#------------------------------------------------------------------------------

echo "Waiting for neutron to start."
until neutron net-list >/dev/null 2>&1; do
    sleep 1
done

echo "Creating the external network."
neutron net-create ext-net --shared --router:external=True

echo "Creating a subnet on the external network."
neutron subnet-create ext-net \
    --name ext-subnet \
    --allocation-pool start="$FLOATING_IP_START,end=$FLOATING_IP_END" \
    --disable-dhcp \
    --gateway "$EXTERNAL_NETWORK_GATEWAY" \
    "$EXTERNAL_NETWORK_CIDR"
