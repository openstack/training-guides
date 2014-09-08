#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
# Pick up VM_PROXY
source "$CONFIG_DIR/localrc"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

function set_apt_proxy {
    local PRX_KEY="Acquire::http::Proxy"
    local APT_FILE=/etc/apt/apt.conf

    if [ -f $APT_FILE ] && grep -q $PRX_KEY $APT_FILE; then
        # apt proxy has already been set (by preseed/kickstart)
        if [ -n "${VM_PROXY-}" ]; then
            # Replace with requested proxy
            sudo sed -i "s#^\($PRX_KEY\).*#\1 \"$VM_PROXY\";#" $APT_FILE
        else
            # No proxy requested -- remove
            sudo sed -i "s#^$PRX_KEY.*##" $APT_FILE
        fi
    elif [ -n "${VM_PROXY-}" ]; then
        # Proxy requested, but none configured: add line
        echo "$PRX_KEY \"$VM_PROXY\";" | sudo tee -a $APT_FILE
    fi
}

set_apt_proxy

# Get apt index files
sudo apt-get update

function ubuntu_cloud_archive {
    # cloud-keyring to verify packages from ubuntu-cloud repo
    sudo apt-get install ubuntu-cloud-keyring

    # Install packages needed for add-apt-repository
    sudo apt-get -y install software-properties-common \
                            python-software-properties
    sudo add-apt-repository -y "cloud-archive:$OPENSTACK_RELEASE"

    # Get index files only for ubuntu-cloud repo but keep standard lists
    sudo apt-get update \
        -o Dir::Etc::sourcelist="sources.list.d/cloudarchive-$OPENSTACK_RELEASE.list" \
        -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
}

if grep -qs DISTRIB_CODENAME=precise /etc/lsb-release; then
    ubuntu_cloud_archive
fi
