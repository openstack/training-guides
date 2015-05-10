#!/bin/bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/deploy.osbash"
source "$OSBASH_LIB_DIR/functions-host.sh"

# Get remote ssh port of target node (VM_SSH_PORT)
source "$CONFIG_DIR/config.controller"

if [ $# -eq 0 ]; then
    echo "Purpose: Copy one script to target node and execute it via ssh."
    echo "Usage: $0 <script>"
    exit 1
fi

SCRIPT_SRC=$1

if [ ! -f "$SCRIPT_SRC" ]; then
    echo "File not found: $SCRIPT_SRC"
    exit 1
fi
SCRIPT=$(basename "$SCRIPT_SRC")

wait_for_ssh "$VM_SSH_PORT"

function get_remote_top_dir {
    if vm_ssh "$VM_SSH_PORT" "test -d /osbash"; then
        # The installation uses a VirtualBox shared folder.
        echo >&2 -n "Waiting for shared folder."
        until vm_ssh "$VM_SSH_PORT" "test -f $REMOTE_TOP_DIR/lib"; do
            sleep 1
            echo >&2 -n .
        done
        echo >&2
        echo /osbash
    else
        # Copy and execute the script with scp/ssh.
        echo /home/osbash
    fi
}

REMOTE_TOP_DIR=$(get_remote_top_dir)

EXE_DIR_NAME=test_tmp
mkdir -p "$TOP_DIR/$EXE_DIR_NAME"
cp -f "$SCRIPT_SRC" "$TOP_DIR/$EXE_DIR_NAME"

if [[ "$REMOTE_TOP_DIR" = "/home/osbash" ]]; then
    # Not using a shared folder, we need to scp the script to the target node
    vm_scp_to_vm "$VM_SSH_PORT" "$TOP_DIR/$EXE_DIR_NAME/$SCRIPT"
fi

vm_ssh "$VM_SSH_PORT" "bash -c $REMOTE_TOP_DIR/$EXE_DIR_NAME/$SCRIPT" || \
    rc=$?
echo "$SCRIPT returned status: ${rc:-0}"
