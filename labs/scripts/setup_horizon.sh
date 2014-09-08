#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Dashboard (horizon).
#------------------------------------------------------------------------------

echo "Installing horizon."
sudo apt-get install -y openstack-dashboard memcached

echo "Purging Ubuntu theme."
sudo dpkg --purge openstack-dashboard-ubuntu-theme

echo "Reloading apache and memcached service."
sudo service apache2 restart
sudo service memcached restart
