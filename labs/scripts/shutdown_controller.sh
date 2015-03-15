#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

# At this point in the cluster build, we just rebooted the compute VM to take
# a snapshot, and we are about to reboot the controller node for the same
# purpose.
#
# About a minute after we reboot the controller, the status of nova-compute
# (according to nova-manage service list) becomes "XXX".
#
# If we sleep for 2 seconds now, before rebooting the controller, the
# nova-compute service on the compute node will keep running and the status
# will automatically return to ":-)" after some time (may take several
# minutes). If we don't sleep here, the nova-compute service on compute will
# die within a few minutes (needs manual service restart or a compute node
# reboot).
sleep 2

echo "Shutting down the controller node."
ssh \
    -o "UserKnownHostsFile /dev/null" \
    -o "StrictHostKeyChecking no" \
    -i "$HOME/.ssh/osbash_key" \
    controller-mgmt \
    sudo /sbin/shutdown -P now
