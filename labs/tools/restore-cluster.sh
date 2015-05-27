#!/bin/bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/deploy.osbash"
source "$CONFIG_DIR/provider.virtualbox"
source "$OSBASH_LIB_DIR/functions-host.sh"
source "$OSBASH_LIB_DIR/virtualbox-functions.sh"

OSBASH=exec_cmd

VM_LIST="controller network compute"

function usage {
    # Setting to empty string selects latest (current snapshot)
    echo "Usage: $0 {-l|-c|-t <SNAP>} [-s]"
    echo ""
    echo "-h        Help"
    echo "-l        List snapshots for node VMs"
    echo "-c        Restore cluster node VMs to current snapshot"
    echo "-t SNAP   Restore cluster to target snapshot"
    echo "-s        Start each node VMs after restoring it"
    exit
}

function list_snapshots {
    for vm_name in $VM_LIST; do
        echo -e "Snapshot list for $vm_name node:"
        vboxmanage snapshot "$vm_name" list
        echo
    done
    exit 0
}

while getopts :chlst: opt; do
    case $opt in
        c)
            CURRENT=yes
            ;;
        h)
            usage
            ;;
        l)
            list_snapshots
            ;;
        s)
            START=yes
            ;;
        t)
            TARGET_SNAPSHOT=$OPTARG
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

if [ $# -ne 0 ]; then
    usage
elif [ -z "${TARGET_SNAPSHOT:-}" -a -z "${CURRENT:-""}" ]; then
    echo
    echo "Error: no target snapshot given."
    echo
    usage
elif [ -n "{$TARGET_SNAPSHOT:-}" -a -n "${CURRENT:-""}" ]; then
    echo
    echo "Error: conflicting options: target snapshot name and -c."
    echo
    usage
fi

# Find target_snapshot in scripts_cfg and set global *_SNAPSHOT variables
# to the correct snapshot name for each node (to allow building from there)
function set_snapshot_vars {
    local target_snapshot=$1

    local found=0
    local scripts_cfg="$TOP_DIR/config/scripts.ubuntu_cluster"

    while read -r line; do
        if [[ $line =~ ^cmd\ snapshot.*-n\ ([^ ]*)\ (.*) ]]; then
            # Node name (e.g. controller)
            node=${BASH_REMATCH[1]}

            # Snapshot name (e.g. keystone_installed)
            snapshot=${BASH_REMATCH[2]}

            # Global variable name (e.g. CONTROLLER_SNAPSHOT)
            # Can't use ${node,,} (OS X bash version is only 3.2)
            var_name=$(echo "$node"|tr "a-z" "A-Z")_SNAPSHOT

            if [ "$snapshot" = "$target_snapshot" ]; then
                # Can't use associative arrays (OS X bash version is only 3.2)
                eval "${var_name}=$snapshot"

                found=1
            elif [ $found -eq 0 ]; then
                eval "${var_name}=$snapshot"
            fi
        fi
    done < "$scripts_cfg"

    if [ $found -eq 0 ]; then
        echo "ERROR: snapshot '$target_snapshot' not found"
        exit 1
    fi
}

function restore_current_snapshot {
    local vm_name=$1
    vboxmanage snapshot "$vm_name" restorecurrent
}

function restore_named_snapshot {
    local vm_name=$1
    local snapshot=$2
    vboxmanage snapshot "$vm_name" restore "$snapshot"
}

if [ -n "$TARGET_SNAPSHOT" ]; then
    set_snapshot_vars "$TARGET_SNAPSHOT"
fi

for vm_name in $VM_LIST; do
    vm_power_off "$vm_name"
    vm_wait_for_shutdown "$vm_name"

    if [ "${CURRENT:-""}" = "yes" ]; then
        restore_current_snapshot "$vm_name"
        if [ "${START:-""}" = "yes" ]; then
            vbox_boot "$vm_name"
        fi
    else
        # Global variable name (e.g. CONTROLLER_SNAPSHOT)
        # (use tr due to OS X bash limitation)
        var_name=$(echo "$vm_name"|tr "a-z" "A-Z")_SNAPSHOT
        if [ -z "${!var_name:=""}" ]; then
            vm_delete "$vm_name"
        else
            restore_named_snapshot "$vm_name" "${!var_name}"
            if [ "${START:-""}" = "yes" ]; then
                vbox_boot "$vm_name"
            fi
        fi
    fi
done

