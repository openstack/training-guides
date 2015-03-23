#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

# Upgrade installed packages
sudo yum -y update
