#!/usr/bin/env bash

set -o errexit
set -o nounset

# Kill entire process group
trap 'kill -- -$$' SIGINT

TOP_DIR=$(cd $(dirname "$0") && pwd)

: ${DISTRO:=ubuntu-14.04-server-amd64}

source "$TOP_DIR/config/localrc"
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
source "$CONFIG_DIR/deploy.osbash"
source "$CONFIG_DIR/provider.virtualbox"
source "$OSBASH_LIB_DIR/lib.$DISTRO"
source "$OSBASH_LIB_DIR/functions.host"
source "$OSBASH_LIB_DIR/virtualbox.functions"
source "$OSBASH_LIB_DIR/virtualbox.install_base"

function usage {
    echo "Usage: $0 [-h] [-r] [-w|-f] [-e] [-n] {basedisk|cluster|<node names>}"
    echo ""
    echo "-h        Help"
    echo "-n        Print configuration status and exit"
    echo "-w        Create Windows batch files, too"
    echo "-f        Only create Windows batch files (fast)"
    echo "-e        Export OVA file of VM cluster"
    echo ""
    echo "basedisk  Create configured basedisk"
    echo "cluster   Create configured VM cluster (and basedisk if necessary)"
    exit
}

function print_config {
    if [ "$CMD" = "basedisk" ]; then
        echo "Target is base disk: $BASE_DISK"
    else
        echo "Base disk: $BASE_DISK"
        echo "Nodes: $nodes"
    fi

    if [ -n "${EXPORT_OVA:-}" ]; then
        echo "Exporting to OVA: ${EXPORT_OVA}"
    else
        echo -n "Creating Windows batch scripts: "
        ${WBATCH:-:} echo "yes"
        ${WBATCH:+:} echo "no"

        echo -n "Creating $CMD on this machine: "
        ${OSBASH:-:} echo "yes"
        ${OSBASH:+:} echo "no"

        echo "VM access method: $VM_ACCESS"
    fi

}

while getopts :efhnw opt; do
    case $opt in
        e)
            EXPORT_OVA=$IMG_DIR/oslabs-$DISTRO.ova
            ;;
        f)
            source "$LIB_DIR/wbatch/batch_for_windows"
            wbatch_reset
            unset OSBASH
            ;;
        h)
            usage
            ;;
        n)
            INFO_ONLY=1
            ;;
        w)
            source "$LIB_DIR/wbatch/batch_for_windows"
            ;;
        ?)
            echo "Error: invalid option -$OPTARG"
            echo
            usage
            ;;
    esac
done

# Remove processed options from arguments
shift $(( OPTIND - 1 ));

if [ $# -eq 0 ]; then
    # No argument given
    usage
elif [ "$1" = basedisk ]; then
    # Building the base disk only
    CMD=$1
else
    CMD=nodes
    if [ "$1" = cluster ]; then
        nodes="controller compute network"
    else
        nodes="$@"
    fi
fi

# Install over ssh by default
: ${VM_ACCESS:=ssh}

# Get base disk path if none is configured
: ${BASE_DISK:=$(get_base_disk_path)}

print_config

if [ "${INFO_ONLY:-0}" -eq 1 ]; then
    exit
fi

if [ -n "${EXPORT_OVA:-}" ]; then
    vm_export_ova "$EXPORT_OVA" "$nodes"
    exit
fi

echo >&2 "$(date) osbash starting"

clean_dir "$LOG_DIR"

function cleanup_base_disk {
    if [ "$CMD" = basedisk -a -f "$BASE_DISK" ]; then

        echo >&2 "Found existing base disk: $BASE_DISK"

        if ! yes_or_no "Keep this base disk?"; then
            if disk_registered "$BASE_DISK"; then
                # Remove users of base disk
                echo >&2 "Unregistering and removing all disks attached to" \
                            "base disk path."
                disk_delete_child_vms "$BASE_DISK"
                echo >&2 "Unregistering old base disk."
                disk_unregister "$BASE_DISK"
            fi
            echo >&2 "Removing old base disk."
            rm -f "$BASE_DISK"
        else
            echo >&2 "Nothing to do. Exiting."
            exit
        fi
    fi
}

${OSBASH:-:} cleanup_base_disk

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ ! -f "$BASE_DISK" ]; then
    vm_install_base "$BASE_DISK"
else
    # Leave base disk alone, but call the function if wbatch is active
    OSBASH= ${WBATCH:-:} vm_install_base "$BASE_DISK"
fi
#-------------------------------------------------------------------------------
if [ "$CMD" = basedisk ]; then
    exit
fi

echo "Using base disk $BASE_DISK"

${WBATCH:-:} wbatch_create_hostnet
MGMT_NET_IF=$(create_network "$MGMT_NET")
DATA_NET_IF=$(create_network "$DATA_NET")
API_NET_IF=$(create_network "$API_NET")
#-------------------------------------------------------------------------------
source "$OSBASH_LIB_DIR/virtualbox.install_node"
for node in $nodes; do
    vm_build_node "$node"
done
#-------------------------------------------------------------------------------
echo >&2 "$(date) osbash finished successfully"
