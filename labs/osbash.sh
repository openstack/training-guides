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
    echo "Usage: $0 {-b|-w} [-g GUI] [-n] {basedisk|NODE [NODE..]}"
    echo "       $0 [-e EXPORT] [-n] NODE [NODE..]"
    # Don't advertise export until it is working properly
    #echo "       $0 [-e EXPORT] [-n] NODE [NODE..]"
    echo ""
    echo "-h        Help"
    echo "-n        Print configuration status and exit"
    echo "-b        Build basedisk (if necessary) and node VMs (if any)"
    echo "-w        Create Windows batch files"
    echo "-g GUI    GUI type during build"
    #echo "-e EXPORT Export node VMs"
    echo ""
    echo "basedisk  Build configured basedisk"
    echo "NODE      Build controller, compute, network, cluster [all three]"
    echo "          (builds basedisk if necessary)"
    echo "GUI       gui, sdl, or headless"
    echo "          (choose GUI type for VirtualBox)"
    #echo "EXPORT    ova (OVA package file) or dir (VM clone directory)"
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
    elif [ -n "${EXPORT_VM_DIR:-}" ]; then
        echo "Exporting to directory: ${EXPORT_VM_DIR}"
    else
        echo -n "Creating Windows batch scripts: "
        ${WBATCH:-:} echo "yes"
        ${WBATCH:+:} echo "no"

        echo -n "Creating $CMD on this machine: "
        ${OSBASH:-:} echo "yes"
        ${OSBASH:+:} echo "no"

        echo "VM access method: $VM_ACCESS"

        # GUI is the VirtualBox default
        echo "GUI type: ${VM_UI:-gui}"
    fi

}

while getopts :be:g:hnw opt; do
    case $opt in
        e)
            if [ "$OPTARG" = ova ]; then
                EXPORT_OVA=$IMG_DIR/oslabs-$DISTRO.ova
            elif [ "$OPTARG" = dir ]; then
                EXPORT_VM_DIR=$IMG_DIR/oslabs-$DISTRO
            else
                echo "Error: -e argument must be ova or dir"
                exit
            fi
            OSBASH=exec_cmd
            ;;
        b)
            OSBASH=exec_cmd
            ;;
        g)
            if [[ "$OPTARG" =~ (headless|gui|sdl) ]]; then
                VM_UI=$OPTARG
            else
                echo "Error: -g argument must be gui, sdl, or headless"
                exit
            fi
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
        :)
            echo "Error: -$OPTARG needs argument"
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

# Clean wbatch directory
${WBATCH:-:} wbatch_reset

if [ -n "${EXPORT_OVA:-}" ]; then
    vm_export_ova "$EXPORT_OVA" "$nodes"
    exit
fi

if [ -n "${EXPORT_VM_DIR:-}" ]; then
    vm_export_dir "$EXPORT_VM_DIR" "$nodes"
    exit
fi

if [ -z "${OSBASH:-}" -a -z "${WBATCH:-}" ]; then
    echo
    echo "No -b, -w, or -e option given. Exiting."
    exit
fi

STARTTIME=$(date +%s)
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
ENDTIME=$(date +%s)
echo >&2 "$(date) osbash finished successfully"
echo "osbash completed in $(($ENDTIME - $STARTTIME)) seconds."
