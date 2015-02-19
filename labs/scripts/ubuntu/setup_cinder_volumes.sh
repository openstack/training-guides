#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$CONFIG_DIR/openstack"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/admin-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up Block Storage service (cinder).
# http://docs.openstack.org/juno/install-guide/install/apt/content/cinder-install-storage-node.html
#------------------------------------------------------------------------------

# Get FOURTH_OCTET for this node
source "$CONFIG_DIR/config.$(hostname)"

MY_MGMT_IP=$(get_ip_from_net_and_fourth "MGMT_NET" "$FOURTH_OCTET")
echo "IP address of this node's interface in management network: $MY_MGMT_IP."

echo "Installing the Logical Volume Manager (LVM)."
sudo apt-get install -y lvm2

echo "Configuring LVM physical and logical volumes."

# We don't have a dedicated physical partition for cinder to use; instead,
# we configure a file-backed loopback device.
cinder_loop_path=/var/lib/cinder-volumes
cinder_loop_dev=/dev/loop2
sudo dd if=/dev/zero of=$cinder_loop_path bs=1 count=0 seek=4G
sudo losetup $cinder_loop_dev $cinder_loop_path

# Tell upstart to run losetup again when the system is rebooted
cat << UPSTART | sudo tee "/etc/init/cinder-losetup.conf"
description "Set up loop device for cinder."

start on mounted MOUNTPOINT=/
task
exec /sbin/losetup $cinder_loop_dev $cinder_loop_path
UPSTART

sudo pvcreate $cinder_loop_dev
sudo vgcreate cinder-volumes $cinder_loop_dev

# We could configure LVM to only use loopback devices or only the device
# we just set up, but scanning our block devices to find our volume group
# is fast enough.

echo "Installing cinder."
sudo apt-get install -y cinder-volume python-mysqldb

conf=/etc/cinder/cinder.conf
echo "Configuring $conf."

function get_database_url {
    local db_user=$(service_to_db_user cinder)
    local db_password=$(service_to_db_password cinder)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/cinder"
}

database_url=$(get_database_url)

echo "Setting database connection: $database_url."
iniset_sudo $conf database connection "$database_url"

# Configure [DEFAULT] section.
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

iniset_sudo $conf DEFAULT auth_strategy keystone

# Configure [keystone_authtoken] section.
cinder_admin_user=$(service_to_user_name cinder)
cinder_admin_password=$(service_to_user_password cinder)
iniset_sudo $conf keystone_authtoken auth_uri http://controller-mgmt:5000/v2.0
iniset_sudo $conf keystone_authtoken identity_uri http://controller-mgmt:35357
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$cinder_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$cinder_admin_password"

iniset_sudo $conf DEFAULT my_ip "$MY_MGMT_IP"

iniset_sudo $conf DEFAULT glance_host controller-mgmt

iniset_sudo $conf DEFAULT verbose True

echo "Restarting cinder service."
sudo service tgt restart
sudo service cinder-volume restart

sudo rm -f /var/lib/cinder/cinder.sqlite

#------------------------------------------------------------------------------
# Verify the Block Storage installation
# http://docs.openstack.org/juno/install-guide/install/apt/content/cinder-verify.html
#------------------------------------------------------------------------------

echo "Verifying Block Storage installation on controller node."

echo "Sourcing the admin credentials."
AUTH="source $CONFIG_DIR/admin-openstackrc.sh"

echo "Waiting for cinder to start."
until node_ssh controller-mgmt "$AUTH; cinder service-list" >/dev/null 2>&1; do
    sleep 1
done

echo "cinder service-list"
node_ssh controller-mgmt "$AUTH; cinder service-list"

echo "Sourcing the demo credentials."
AUTH="source $CONFIG_DIR/demo-openstackrc.sh"

echo "cinder create --display-name demo-volume1 1"
node_ssh controller-mgmt "$AUTH; cinder create --display-name demo-volume1 1"

echo "cinder list"
# FIXME check Status column (may be creating, available, or error)
node_ssh controller-mgmt "$AUTH; cinder list"

echo "cinder delete demo-volume1"
node_ssh controller-mgmt "$AUTH; cinder delete demo-volume1"

echo "cinder list"
node_ssh controller-mgmt "$AUTH; cinder list"
