#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/demo-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------

# Work around neutron client failing with unsupported locale settings
if [[ "$(neutron --help)" == "unsupported locale setting" ]]; then
    echo "Locale not supported on node, setting LC_ALL=C."
    export LC_ALL=C
fi

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
