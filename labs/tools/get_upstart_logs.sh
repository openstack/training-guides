#!/bin/bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/deploy.osbash"
source "$OSBASH_LIB_DIR/functions-host.sh"

CONTROLLER_PORT=2230
NETWORK_PORT=2231
COMPUTE_PORT=2232

function usage {
    echo "Purpose: Get logs from cluster node VMs."
    echo "Usage: $0 [<target_root>]"
    exit 1
}

if [ $# = 0 ]; then
    usage
else
    RESULTS_DIR=$1
    if [ ! -d "$RESULTS_DIR" ]; then
        echo >&2 "Error: no such directory: $RESULTS_DIR"
        exit 1
    fi
fi

for port in "$CONTROLLER_PORT" "$NETWORK_PORT" "$COMPUTE_PORT"; do
    port_dir=$RESULTS_DIR/$port
    mkdir "$port_dir"
    vm_ssh "$port" "sudo tar cf - -C /var/log upstart" | tar xf - -C "$port_dir"
done

if vm_ssh "$CONTROLLER_PORT" 'ls log/test-*.*' >/dev/null 2>&1; then
    vm_ssh "$CONTROLLER_PORT" 'cd log; tar cf - test-*.*' | tar xf - -C "$RESULTS_DIR"
    vm_ssh "$CONTROLLER_PORT" 'rm log/test-*.*'
fi
