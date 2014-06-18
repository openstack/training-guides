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
sudo apt-get install -y --download-only bridge-utils cinder-api cinder-scheduler cinder-volume glance iscsitarget iscsitarget-dkms keystone libvirt-bin memcached mysql-server neutron-dhcp-agent neutron-l3-agent neutron-plugin-openvswitch-agent neutron-server nova-ajax-console-proxy nova-api nova-cert nova-compute-kvm nova-conductor nova-consoleauth nova-doc nova-novncproxy nova-scheduler novnc ntp open-iscsi openstack-dashboard openvswitch-datapath-dkms openvswitch-switch pm-utils python-guestfs python-mysqldb python-novaclient rabbitmq-server vlan
