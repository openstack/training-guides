#!/bin/bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/deploy.osbash"
source "$OSBASH_LIB_DIR/functions.host"

CONTROLLER_VM=controller
NETWORK_VM=network
COMPUTE_VM=compute

function usage {
    # Setting to empty string selects latest (current snapshot)
    echo "Usage: $0 {current|<controller_snapshot_name>} {list-snapshots}"
    echo "       current: restore to currently active snapshot"
    echo "       list-snapshots: to list the snapshots of the vms"
    exit
}

function cluster_restore {
    vboxmanage controlvm $CONTROLLER_VM poweroff >/dev/null 2>&1 || rc=$?
    sleep 1
    if [ -n "$CONTROLLER_SNAPSHOT" ]; then
        echo "Restoring $CONTROLLER_SNAPSHOT."
        vboxmanage snapshot $CONTROLLER_VM restore "$CONTROLLER_SNAPSHOT"
    else
        echo "Restoring current snapshot."
        vboxmanage snapshot $CONTROLLER_VM restorecurrent
    fi

    vboxmanage controlvm $COMPUTE_VM poweroff >/dev/null 2>&1 || rc=$?
    sleep 1
    vboxmanage snapshot $COMPUTE_VM restorecurrent

    vboxmanage controlvm $NETWORK_VM poweroff >/dev/null 2>&1 || rc=$?
    sleep 1
    vboxmanage snapshot $NETWORK_VM restorecurrent
}

function cluster_start {
    vboxmanage startvm $CONTROLLER_VM -t headless
    vboxmanage startvm $COMPUTE_VM -t headless
    vboxmanage startvm $NETWORK_VM -t headless
}

function list_snapshots {

    for node in $CONTROLLER_VM $COMPUTE_VM $NETWORK_VM; do
        echo -e "\n$node node's Snapshot"
        vboxmanage snapshot $node list
        echo
        echo
        sleep 1
    done

    exit 0
}

# Call the main brains
if [ $# -eq 0 ]; then
    usage
elif [ "$1" = "list-snapshots" ]; then
    list_snapshots
elif [ "$1" = "current" ]; then
    CONTROLLER_SNAPSHOT=""
else
    CONTROLLER_SNAPSHOT=$1
fi


echo "Restoring cluster snapshots."
cluster_restore

echo "Starting VMs."
cluster_start >/dev/null
