#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

# Download CirrOS image
function get_cirros {
    local file_name=$(basename $CIRROS_URL)
    local remote_dir=$(dirname $CIRROS_URL)
    local md5_f=$file_name.md5sum

    mkdir -p "$IMG_DIR"

    # Download to IMG_DIR to cache the data if the directory is shared
    # with the host computer.
    if [ ! -f "$IMG_DIR/$md5_f" ]; then
        wget -O - "$remote_dir/MD5SUMS"|grep "$file_name" > "$IMG_DIR/$md5_f"
    fi

    if [ ! -f "$IMG_DIR/$file_name" ]; then
        wget --directory-prefix="$IMG_DIR" "$CIRROS_URL"
    fi

    # Make sure we have image and MD5SUM on the basedisk.
    if [ "$IMG_DIR" != "$HOME/img" ]; then
        mkdir -p "$HOME/img"
        cp -a "$IMG_DIR/$file_name" "$IMG_DIR/$md5_f" "$HOME/img"
    fi

    cd "$HOME/img"
    md5sum -c "$HOME/img/$md5_f"
    cd -
}
get_cirros

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
apt_download neutron-server neutron-plugin-ml2 neutron-lbaas-agent

# Cinder Controller
apt_download cinder-api cinder-scheduler

# Horizon
apt_download openstack-dashboard memcached

# Cinder Volumes
apt_download lvm2 cinder-volume

# Nova Compute
apt_download nova-compute-qemu sysfsutils

# Neutron Compute
apt_download neutron-common neutron-plugin-ml2 \
    neutron-plugin-openvswitch-agent

# Neutron Network
apt_download neutron-common neutron-plugin-ml2 \
    neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent

# Heat
apt_download heat-api heat-api-cfn heat-engine python-heatclient

# Ceilometer
apt_download mongodb-server mongodb-clients python-pymongo \
    ceilometer-api ceilometer-collector ceilometer-agent-central \
    ceilometer-agent-notification ceilometer-alarm-evaluator \
    ceilometer-alarm-notifier ceilometer-agent-compute \
    python-ceilometerclient
