# This file contains bash functions that are used by osbash on the host.

source "$LIB_DIR/functions.sh"

#-------------------------------------------------------------------------------
# Conditional execution
#-------------------------------------------------------------------------------
# TODO: Create a help function and display it under help by default or with
# option --help (-h).
# exec_cmd is used for conditional execution:
#
# OSBASH=exec_cmd
#
# Execute command only if OSBASH is set:
# ${OSBASH:-:} cmd args
#
# Execute command only if OSBASH is not set:
# ${OSBASH:+:} cmd args
#
# Disable actual call to VBoxManage (selectively override configuration):
# OSBASH= cmd args
#
# Enable call to VBoxManage (selectively override configuration):
# OSBASH=exec_cmd cmd args

function exec_cmd {
    local cmd=$1
    shift
    $cmd "$@"
}

#-------------------------------------------------------------------------------
function get_base_disk_name {
    echo "base-$VM_ACCESS-$DISTRO.vdi"
}

function get_base_disk_path {
    echo "$DISK_DIR/$(get_base_disk_name)"
}

# From DISTRO string (e.g., ubuntu-14.04-server-amd64), get first component
function get_distro_name {
    # Match up to first dash
    local re='([^-]*)'

    if [[ $DISTRO =~ $re ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

#-------------------------------------------------------------------------------
# ssh
#-------------------------------------------------------------------------------

# Check permission for osbash insecure private key
function check_osbash_private_key {
    local key_name="osbash_key"
    local osbash_key_dir=$LIB_DIR/osbash-ssh-keys
    local osbash_key_path=$osbash_key_dir/$key_name

    if ! ls -l "$osbash_key_path"|grep -q "^-r--------"; then
        echo "Adjusting permissions for $osbash_key_path"
        chmod 400 "$osbash_key_path"
    fi
}

function strip_top_dir {
    local full_path=$1
    echo "${full_path/$TOP_DIR\//}"
}

# Copy files or directories to VM (incl. implied directories; HOME is TOP_DIR)
function vm_scp_to_vm {
    local ssh_port=$1
    shift

    check_osbash_private_key

    while (($#)); do
        local src_path=$1
        shift
        local target_path=$(strip_top_dir "$src_path")
        local target_dir=$(dirname "$target_path")
        vm_ssh "$ssh_port" "mkdir -p $target_dir"
        scp -q -r \
            -i "$LIB_DIR/osbash-ssh-keys/osbash_key" \
            -o "UserKnownHostsFile /dev/null" \
            -o "StrictHostKeyChecking no" \
            -P "$ssh_port" \
            "$src_path" "$VM_SHELL_USER@localhost:$target_path"
    done
}

# Execute commands via ssh
function vm_ssh {
    local ssh_port=$1
    shift

    check_osbash_private_key

    # Some operating systems (e.g., Mac OS X) export locale settings to the
    # target that cause some Python clients to fail. Override with a standard
    # setting (LC_ALL=C).
    LC_ALL=C ssh -q \
        -i "$LIB_DIR/osbash-ssh-keys/osbash_key" \
        -o "UserKnownHostsFile /dev/null" \
        -o "StrictHostKeyChecking no" \
        -p "$ssh_port" \
        "$VM_SHELL_USER@localhost" "$@"
}

function wait_for_ssh {
    local ssh_port=$1

    echo -e -n "${CStatus:-}Waiting for ssh server to respond on local port ${CData:-}$ssh_port.${CReset:-}"
    while [ : ]; do
        if vm_ssh "$ssh_port" exit ; then
            break
        else
            echo -n .
            sleep 1
        fi
    done
    echo
}

# Copy one script to VM and execute it via ssh; log output to separate file
function ssh_exec_script {
    local ssh_port=$1
    local script_path=$2

    vm_scp_to_vm "$ssh_port" "$script_path"

    local remote_path=$(strip_top_dir "$script_path")

    echo -en "\n$(date) start $remote_path"

    local script_name="$(basename "$script_path" .sh)"
    local prefix=$(get_next_prefix "$LOG_DIR" "auto")
    local log_path=$LOG_DIR/${prefix}_${script_name}.auto

    local rc=0
    vm_ssh "$ssh_port" "bash $remote_path && rm -vf $remote_path" \
        > "$log_path" 2>&1 || rc=$?
    if [ $rc -ne 0 ]; then
        echo >&2
        echo -e "${CError:-}ERROR: ssh returned status ${CData:-}$rc${CError:-} for${CData:-} $remote_path${CReset:-}" |
            tee >&2 -a "$LOG_DIR/error.log"
        # kill osbash host scripts
        kill -- -$$
    fi

    echo -en "\n$(date)  done"
}

# Wait for sshd, prepare autostart dirs, and execute autostart scripts on VM
function ssh_process_autostart {
    # Run this function in sub-shell to protect our caller's environment
    # (which might be _our_ enviroment if we get called again)
    (

    source "$CONFIG_DIR/config.$vm_name"

    local ssh_port=$VM_SSH_PORT

    wait_for_ssh "$ssh_port"
    vm_ssh "$ssh_port" "rm -rf lib config autostart"
    vm_scp_to_vm "$ssh_port" "$TOP_DIR/lib" "$TOP_DIR/config"

    local script_path=""
    for script_path in "$AUTOSTART_DIR/"*.sh; do
        ssh_exec_script "$ssh_port" "$script_path"
        rm -f "$script_path" >&2
    done
    touch "$STATUS_DIR/done"

    )
}

#-------------------------------------------------------------------------------
# Autostart mechanism
#-------------------------------------------------------------------------------

function autostart_reset {
    clean_dir "$AUTOSTART_DIR"
    clean_dir "$STATUS_DIR"
}

function process_begin_files {
    local processing=("$STATUS_DIR"/*.sh.begin)
    if [ -n "${processing[0]-}" ]; then
        local file
        for file in "${processing[@]}"; do
            echo >&2 -en "\nVM processing $(basename "$file" .begin)"
            rm "$file"
        done
    fi
}

# Wait until all autofiles are processed (indicated by a "$STATUS_DIR/done"
# file created either by osbashauto or ssh_process_autostart)
function wait_for_autofiles {
    shopt -s nullglob

    ${WBATCH:-:} wbatch_wait_auto
    # Remove autostart files and return if we are just faking it for wbatch
    ${OSBASH:+:} autostart_reset
    ${OSBASH:+:} return 0

    until [ -f "$STATUS_DIR/done" -o -f "$STATUS_DIR/error" ]; do
        # Note: begin files (created by indicate_current_auto) are only visible
        # if the STATUS_DIR directory is shared between host and VM
        ${WBATCH:-:} process_begin_files
        echo >&2 -n .
        sleep 1
    done
    # Check for remaining *.sh.begin files
    ${WBATCH:-:} process_begin_files
    if [ -f "$STATUS_DIR/done" ]; then
        rm "$STATUS_DIR/done"
    else
        echo -e >&2 "${CError:-}\nERROR occured. Exiting.${CReset:-}"
        kill -- -$$
    fi
    echo
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Prepending numbers ensures scripts will be executed in the order they
# were added to the queue.

function _autostart_queue {
    local src_path=$SCRIPTS_DIR/$1
    local src_name=${1##*/}

    # If we get a target name, file will be renamed
    local target_name=${2:-$src_name}

    if [[ $target_name = *.sh ]]; then
        # Create target file name like 01_apt_init.sh
        local prefix=$(get_next_prefix "$AUTOSTART_DIR" "sh" 2)
        target_name="${prefix}_$target_name"
    fi

    if [ "$src_name" = "$target_name" ]; then
        echo >&2 -e "\t$src_name"
    else
        echo >&2 -e "\t$src_name -> $target_name"
    fi

    cp -- "$src_path" "$AUTOSTART_DIR/$target_name"
    ${WBATCH:-:} wbatch_cp_auto "$src_path" "$AUTOSTART_DIR/$target_name"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Print to the console which file requested guest scripts to run
function log_autostart_source {
    # If the caller doesn't provide a config file, log the caller's source file
    local src_file=${1:-${BASH_SOURCE[1]##*/}}
    echo >&2 "Copying autostart files set in $src_file"
}

# autostart <src_dir> <file> <new_name>
# e.g. autostart osbash init_xxx_node.sh init_controller_node.sh
function autostart_and_rename {
    local src_dir=$1
    local src_file=$2
    local target_file=$3

    # Don't log this file -- log our caller's source file
    log_autostart_source "${BASH_SOURCE[1]##*/}"

    _autostart_queue "$src_dir/$src_file" "$target_file"
}

# autostart <file> [<file> ...]
# e.g. autostart zero_empty.sh osbash/base_fixups.sh
function autostart {
    # Don't log this file -- log our caller's source file
    log_autostart_source "${BASH_SOURCE[1]##*/}"

    while (($#)); do
        local src_file=$1
        shift
        _autostart_queue "$src_file"
    done
}

# Parse options given to configuration commands. Return parsed values by
# setting variables to be used by caller.
function get_cmd_options {
    local OPTIND
    local opt

    while getopts :g:n: opt; do
        case $opt in
            g)
                vm_ui=$OPTARG
                ;;
            n)
                vm_name=$OPTARG
                ;;
            *)
                echo -e >&2 "${CError:-}Error: bad option ${CData:-}$OPTARG.${CReset:-}"
                exit 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    # Assign the remaining arguments back to args
    args=$@
}

# Parse command and arguments after a "cmd" token in config/scripts.*
function command_from_config {
    local cmd=$1
    shift

    # Local variables that may be changed by get_cmd_options
    local vm_name=${NODE_NAME:-""}
    local vm_ui=${VM_UI:-""}

    local args=$@
    case "$cmd" in
        boot)
            # Format: boot [-g <gui_type>] [-n <node_name>]
            # Boot with queued autostart files now, wait for end of scripts
            # processing
            get_cmd_options $args
            echo >&2 "VM_UI=$vm_ui _vbox_boot_with_autostart $vm_name"
            VM_UI=$vm_ui _vbox_boot_with_autostart "$vm_name"
            ;;
        snapshot)
            # Format: snapshot [-n <node_name>] <snapshot_name>
            get_cmd_options $args
            local shot_name=$args
            echo >&2 vm_snapshot "$vm_name" "$shot_name"
            vm_snapshot "$vm_name" "$shot_name"
            ;;
        wait_for_shutdown)
            # Format: wait_for_shutdown [-n <node_name>]
            get_cmd_options $args
            echo >&2 vm_wait_for_shutdown "$vm_name"
            vm_wait_for_shutdown "$vm_name"
            ;;
        snapshot_cycle)
            # Format: snapshot_cycle [-g <gui_type>] [-n <node_name>]
            # comprises shutdown, boot, wait_for_shutdown, snapshot
            get_cmd_options $args
            local shot_name=$args
            echo >&2 snapshot_cycle "$vm_name" "$shot_name"
            _autostart_queue "osbash/shutdown.sh"
            _vbox_boot_with_autostart "$vm_name"
            vm_wait_for_shutdown "$vm_name"
            vm_snapshot "$vm_name" "$shot_name"
            ;;
        init_node)
            # Format: init_node [-n <node_name>]
            get_cmd_options $args
            echo >&2 vm_init_node "$vm_name"
            vm_init_node "$vm_name"
            ;;
        queue)
            # Queue a script for autostart
            # Format: queue <script_name>
            local script_rel_path=$args
            echo >&2 _autostart_queue "$script_rel_path"
            _autostart_queue "$script_rel_path"
            ;;
        *)
            echo -e >&2 "${CError:-}Error: invalid cmd: ${CData:-}$cmd${CReset:-}"
            exit 1
            ;;
    esac
}

# Parse config/scripts.* configuration files
function autostart_from_config {
    local config_file=$1
    local config_path=$CONFIG_DIR/$config_file

    if [ ! -f "$config_path" ]; then
        echo -e >&2 "${CMissing:-}Config file not found: ${CData:-}$config_file${CReset:-}"
        return 1
    fi

    log_autostart_source "$config_file"

    # Open file on file descriptor 3 so programs we call in this loop (ssh)
    # are free to mess with the standard file descriptors.
    exec 3< "$config_path"
    while read -r field_1 field_2 <&3; do
        if [[ $field_1 =~ (^$|^#) ]]; then
            # Skip empty lines and lines that are commented out
            continue
        elif [ "$field_1" == "cmd" ]; then
            if [ -n "${JUMP_SNAPSHOT:-""}" ]; then
                if [[ $field_2 =~ ^snapshot.*${JUMP_SNAPSHOT} ]]; then
                    echo >&2 "Skipped forward to snapshot $JUMP_SNAPSHOT."
                    unset JUMP_SNAPSHOT
                fi
            else
                command_from_config $field_2
            fi
        else
            # Syntax error
            echo -e -n >&2 "${CError:-}ERROR in ${CInfo:-}$config_file: ${CData:-}'$field_1${CReset:-}"
            if [ -n "$field_2" ]; then
                echo >&2 " $field_2'"
            else
                echo >&2 "'"
            fi
            exit 1
        fi
    done
}

#-------------------------------------------------------------------------------
# Functions to get install ISO images
#-------------------------------------------------------------------------------

function download {
    local url=$1
    local dest_dir=$2
    local dest_file=$3
    local rc=0

    local wget_exe=$(which wget)
    mkdir -pv "$dest_dir"
    if [ -n "$wget_exe" ]; then
        $wget_exe --output-document "$dest_dir/$dest_file" "$url"||rc=$?
    else
        # Mac OS X has curl instead of wget
        local curl_exe=$(which curl)
        if [ -n "$curl_exe" ]; then
            $curl_exe "$url" -o "$dest_dir/$dest_file"||rc=$?
        fi
    fi
    if [ $rc -ne 0 ]; then
        echo -e >&2 "${CError:-}Unable to download ${CData:-}$url${CError:-}, quitting.${CReset:-}"
        exit 1
    fi
}

function get_iso_name {
    basename "${ISO_URL:-}"
}

function find_install-iso {
    local iso_name=$1
    if [ ! -f "$ISO_DIR/$iso_name" ]; then
        echo >&2 "$iso_name not in $ISO_DIR; downloading"
        download "$ISO_URL" "$ISO_DIR" "$iso_name"
    fi
}

# vim: set ai ts=4 sw=4 et ft=sh:
