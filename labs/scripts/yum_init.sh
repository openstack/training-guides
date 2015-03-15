#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
# Pick up VM_PROXY
source "$CONFIG_DIR/localrc"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

function set_yum_proxy {
    local YUM_FILE=/etc/yum.conf
    if [ -z "${VM_PROXY-}" ]; then
        return 0;
    fi
    echo "proxy=${VM_PROXY}" | sudo tee -a $YUM_FILE
}

set_yum_proxy

# Enable RDO repo
if [[ ${OPENSTACK_RELEASE:-} = icehouse ]]; then
    sudo yum install "http://repos.fedorapeople.org/repos/openstack/openstack-$OPENSTACK_RELEASE/rdo-release-$OPENSTACK_RELEASE-3.noarch.rpm"
else
    echo 2>&1 "ERROR Unknown OpenStack release."
    return 1
fi
