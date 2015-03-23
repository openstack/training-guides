#!/usr/bin/env bash
set -o errexit -o nounset

# This scripts configures hostname and networking for all nodes. The filename
# determines the node name.

TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"

# Determine hostname from script name
re=".*init_(.*)_node.sh$"
if [[ $0 =~ $re ]]; then
    NODE_NAME=${BASH_REMATCH[1]}
    NODE_NAME="${NODE_NAME}"
else
    echo "ERROR Unable to determine hostname"
    exit 1
fi

indicate_current_auto

exec_logfile

# Set hostname for now and for rebooted system
sudo hostname "$NODE_NAME" >/dev/null
echo "$NODE_NAME" | sudo tee /etc/hostname > /dev/null

# Configure network interfaces
config_network
