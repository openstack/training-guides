#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

# This script is run by vm_install_base. It should work on all supported
# distributions.

# match Vagrant which removes 70-persistent-net.rules (so we get the same
# names for our network interfaces)
sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
