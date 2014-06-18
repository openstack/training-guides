#!/usr/bin/env bash
set -o errexit

# Shell provisioning script is renamed and copied to /tmp before being run as
# root
TOP_DIR=/vagrant
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

clean_dir "$LOG_DIR"

exec_logpath "$LOG_DIR/$HOSTNAME.log"

# The Vagrantfile uses precise, so we know it's Ubuntu
for CONFIG_FILE in "scripts.nodeinit_vagrant" "scripts.ubuntu" "scripts.$HOSTNAME"; do
    echo "Config file $CONFIG_FILE"
    get_script_paths_from_config "$CONFIG_FILE" | while read SCR_PATH; do
        echo "$SCR_PATH"
        as_root_exec_script "$SCR_PATH"
    done
done
