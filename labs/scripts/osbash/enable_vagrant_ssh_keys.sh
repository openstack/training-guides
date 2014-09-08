#!/usr/bin/env bash
set -o errexit -o nounset

# This script installs the unsecure Vagrant ssh keys. This allows users to
# log into the VMs using these keys instead of a password.

TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

function install_vagrant_public_key {
    local VAGRANT_KEY_NAME="vagrant.pub"
    local KEY_URL=https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/$VAGRANT_KEY_NAME
    local VAGRANT_KEY_DIR=$LIB_DIR/vagrant-ssh-keys

    if [ ! -f "$VAGRANT_KEY_DIR/$VAGRANT_KEY_NAME" ]; then
        wget --output-document "$VAGRANT_KEY_DIR/$VAGRANT_KEY_NAME" "$KEY_URL"
        if [ $? -ne 0 ]; then
            echo >&2 "Error when downloading $KEY_URL"
            return 1
        fi
    fi

    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    cat "$VAGRANT_KEY_DIR/$VAGRANT_KEY_NAME" >> "$HOME/.ssh/authorized_keys"
    chmod 400 "$HOME/.ssh/authorized_keys"
}

if grep -qs "vagrant insecure public key" "$HOME/.ssh/authorized_keys"; then
    echo "Vagrant insecure public key already installed"
else
    install_vagrant_public_key
fi
