#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

HOST_NAME=$(hostname)
HOST_FILE=/etc/hosts

if ! grep -q "^[^#].*$HOST_NAME" $HOST_FILE; then
    # No active entry for our hostname
    HOST_IP=127.0.1.1
    if grep -q "^$HOST_IP" $HOST_FILE; then
        # Fix the entry for the IP address we want to use
        sudo sed -i "s/^$HOST_IP.*/$HOST_IP $HOST_NAME/" $HOST_FILE
    else
        echo "$HOST_IP $HOST_NAME" | sudo tee -a $HOST_FILE
    fi
fi

# Add entries for the rest of the OpenStack training-labs
cat "$CONFIG_DIR/hosts.multi" | sudo tee -a /etc/hosts
