#!/usr/bin/env bash
set -o errexit

# Shell provisioning script is renamed and copied to /tmp before being run as
# root
TOP_DIR=/vagrant
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

clean_dir "$LOG_DIR"

exec_logpath "$LOG_DIR/$HOSTNAME.log"

function vagrant_start_from_config {
    local config_file=$1
    local config_path=$CONFIG_DIR/$config_file

    if [ ! -f "$config_path" ]; then
        echo >&2 "Config file not found: $config_file"
        return 1
    fi

    while read -r field_1 field_2; do
        if [[ $field_1 =~ ^# ]]; then
            # Skip lines that are commented out
            continue
        elif [[ "$field_1" == "boot" || "$field_1" == "snapshot" ]]; then
            # Skip osbash commands, Vagrant ignores them
            continue
        else
            local dir="$(src_dir_code_to_dir "$field_1")"
            local scr_path=$dir/$field_2
            echo "$scr_path"
            as_root_exec_script "$scr_path"
        fi
    done < "$config_path"
}

# The Vagrantfile uses Ubuntu
for config_file in "scripts.nodeinit_vagrant" "scripts.ubuntu" "scripts.$HOSTNAME"; do
    echo "Config file $config_file"
    vagrant_start_from_config "$config_file"
done
