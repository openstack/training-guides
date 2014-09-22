#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

# Download CirrOS image
CIRROS_URL="http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"
if [ ! -f "$IMG_DIR/$(basename "$CIRROS_URL")" ]; then
    wget --directory-prefix="$IMG_DIR" "$CIRROS_URL"
fi

function apt_download {

    sudo apt-get install -y --download-only "$@"

}

# Download packages for all nodes

# MySQL, RabbitMQ
apt_download mysql-server python-mysqldb rabbitmq-server

# Keystone
apt_download keystone

# Glance
apt_download glance

# Nova Controller
apt_download nova-api nova-cert nova-conductor nova-consoleauth \
    nova-novncproxy nova-scheduler python-novaclient

# Neutron Controller
apt_download neutron-server neutron-plugin-ml2

# Cinder Controller
apt_download cinder-api cinder-scheduler

# Horizon
apt_download openstack-dashboard memcached

# Cinder Volumes
apt_download lvm2 cinder-volume

# Nova Compute
apt_download nova-compute-qemu python-guestfs libguestfs-tools

# Neutron Compute
apt_download neutron-common neutron-plugin-ml2 \
    neutron-plugin-openvswitch-agent

# Neutron Network
apt_download neutron-common neutron-plugin-ml2 \
    neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent
