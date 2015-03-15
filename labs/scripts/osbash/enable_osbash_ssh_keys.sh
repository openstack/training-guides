#!/usr/bin/env bash
set -o errexit -o nounset

# This script installs the insecure osbash ssh keys. This allows users to
# log into the VMs using these keys instead of a password.

TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Install the requested osbash insecure key to $HOME/.ssh.
function get_osbash_key {
    local key_name=$1
    local osbash_key_dir=$LIB_DIR/osbash-ssh-keys

    if [ -f "$HOME/.ssh/$key_name" ]; then
        echo "osbash insecure key already installed: $HOME/.ssh/$key_name."
    else
        echo "Installing osbash insecure key $key_name."
        cp -v "$osbash_key_dir/$key_name" "$HOME/.ssh"
    fi
}

# Authorize named key for ssh logins into this VM.
function authorize_osbash_key {
    local pub_key_path=$1
    local auth_key_path=$HOME/.ssh/authorized_keys
    if grep -qs "osbash insecure public key" "$auth_key_path"; then
        echo "Already authorized."
    else
        cat "$pub_key_path" >> "$auth_key_path"
    fi
}

echo "Installing osbash insecure private key (connections to other VMs)."
get_osbash_key "osbash_key"
chmod 400 "$HOME/.ssh/osbash_key"

get_osbash_key "osbash_key.pub"
chmod 444 "$HOME/.ssh/osbash_key.pub"

echo "Authorizing osbash public key (connections from host and other VMs)."
authorize_osbash_key "$HOME/.ssh/osbash_key.pub"
