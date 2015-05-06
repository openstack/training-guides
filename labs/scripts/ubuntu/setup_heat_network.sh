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
# Verify the Orchestration Service installation
# http://docs.openstack.org/juno/install-guide/install/apt/content/heat-verify.html
#------------------------------------------------------------------------------
echo "Verifying heat installation."

echo "Waiting for heat-engine to start."

AUTH="source $CONFIG_DIR/demo-openstackrc.sh"
until node_ssh controller-mgmt "$AUTH; heat stack-list" >/dev/null 2>&1; do
    sleep 1
done

echo "Creating a test heat template."

node_ssh controller-mgmt "echo '
heat_template_version: 2014-10-16
description: A simple server.

parameters:
  ImageID:
    type: string
    description: Image use to boot a server
  NetID:
    type: string
    description: Network ID for the server

resources:
  server:
    type: OS::Nova::Server
    properties:
      image: { get_param: ImageID }
      flavor: m1.tiny
      networks:
      - network: { get_param: NetID }

outputs:
  private_ip:
    description: IP address of the server in the private network
    value: { get_attr: [ server, first_address ] }' > test-stack.yml"

NET_ID=$(node_ssh controller-mgmt "$AUTH; nova net-list" | awk '/ demo-net / { print $2 }')
img_name=$(basename "$CIRROS_URL" -disk.img)

node_ssh controller-mgmt "$AUTH; heat stack-create -f test-stack.yml \
      -P 'ImageID=$img_name;NetID=$NET_ID' testStack"

echo "Verifying successful creation of stack."

cnt=0
echo "heat stack-list"
until node_ssh controller-mgmt "$AUTH; heat stack-list" 2>/dev/null | grep "CREATE_COMPLETE"; do
    cnt=$((cnt + 1))
    if [ $cnt -eq 60 ]; then
        # Print current stack list to help with debugging
        echo
        node_ssh controller-mgmt "$AUTH; heat stack-list"
        echo "Heat stack creation failed. Exiting."
        echo "[Warning]: Please debug heat services on the
        controller and network node. Heat may not work."
        exit 0
    else
        sleep 1
        echo -n "."
    fi
done

echo "Deleting the test stack."
heat_stack_id=$(node_ssh controller-mgmt "$AUTH; heat stack-list" | awk '/ testStack / {print $2}')

node_ssh controller-mgmt "$AUTH; heat stack-delete $heat_stack_id"
