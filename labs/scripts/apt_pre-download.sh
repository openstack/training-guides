#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

# Download CirrOS image
CIRROS_URL="http://download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img"
if [ ! -f "$IMG_DIR/$(basename "$CIRROS_URL")" ]; then
    wget --directory-prefix="$IMG_DIR" "$CIRROS_URL"
fi

# Download packages for all nodes
sudo apt-get install -y --download-only cinder-api cinder-scheduler lvm2 \
    cinder-volume glance openstack-dashboard memcached keystone \
    neutron-server neutron-plugin-ml2 nova-api nova-cert nova-conductor \
    nova-consoleauth nova-novncproxy nova-scheduler python-novaclient \
    nova-compute-kvm python-guestfs neutron-common \
    neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent
