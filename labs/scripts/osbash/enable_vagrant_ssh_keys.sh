#!/usr/bin/env bash
set -o errexit -o nounset

# This script installs the insecure Vagrant ssh keys. This allows users to
# log into the VMs using these keys instead of a password.

TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Install the requested Vagrant insecure key to $HOME/.ssh. Keep a copy in
# $LIB_DIR/vagrant-ssh-keys (cache if the directory is shared with the host).
function get_vagrant_key {
    local key_name=$1
    local key_url=https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/$key_name
    local vagrant_key_dir=$LIB_DIR/vagrant-ssh-keys

    if [ -f "$HOME/.ssh/$key_name" ]; then
        echo "Vagrant insecure key already installed: $HOME/.ssh/$key_name."
    else
        if [ ! -f "$vagrant_key_dir/$key_name" ]; then
            echo "Downloading Vagrant insecure key $key_name."
            wget --output-document "$vagrant_key_dir/$key_name" "$key_url"
            if [ $? -ne 0 ]; then
                echo >&2 "Error when downloading $key_url"
                return 1
            fi
        fi
        echo "Installing Vagrant insecure key $key_name."
        cp -v "$vagrant_key_dir/$key_name" "$HOME/.ssh"
    fi
}

# Authorize named key for ssh logins into this VM.
function authorize_vagrant_key {
    local pub_key_path=$1
    local auth_key_path=$HOME/.ssh/authorized_keys
    if grep -qs "vagrant insecure public key" "$auth_key_path"; then
        echo "Already authorized."
    else
        cat "$pub_key_path" >> "$auth_key_path"
    fi
}

echo "Installing Vagrant insecure private key (connections to other VMs)."
get_vagrant_key "vagrant"
chmod 400 "$HOME/.ssh/vagrant"

get_vagrant_key "vagrant.pub"
chmod 444 "$HOME/.ssh/vagrant.pub"

echo "Authorizing Vagrant public key (connections from host and other VMs)."
authorize_vagrant_key "$HOME/.ssh/vagrant.pub"
