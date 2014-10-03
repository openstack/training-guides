# This bash library contains the functions that allow osbash to produce
# Windows batch files.

: ${WBATCH_DIR:="$TOP_DIR/wbatch"}

# By default, Windows batch file templates are in the same directory as this
# file
: ${WBATCH_TEMPLATE_DIR:=$(dirname "$BASH_SOURCE")}

# wbatch cannot use ssh for talking to the VM; install VirtualBox guest
# additions
VM_ACCESS=vbadd

#-------------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------------

# See functions.host for definition and explanation of exec_cmd
WBATCH=exec_cmd

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function wbatch_reset {
    clean_dir "$WBATCH_DIR"
}

function wbatch_new_file {
    local file_name=$1
    mkdir -p "$WBATCH_DIR"
    WBATCH_OUT="$WBATCH_DIR/$file_name"
    echo -n > "$WBATCH_OUT"
}

function wbatch_close_file {
    unset WBATCH_OUT
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function wbatch_write_line {
    if [ -n "${WBATCH_OUT:-}" ]; then
        # Don't expand backslash escapes except for ending the line with CRLF
        #
        # Note: Windows batch scripts with LF may seem to work, but (for
        #       instance) jump labels don't work properly
        echo -n "$@" >> "$WBATCH_OUT"
        echo -e "\r" >> "$WBATCH_OUT"
    fi
}

function wbatch_write_stdin {
    local line=""

    # Set IFS to preserve leading whitespace
    while IFS= read -r line; do
        wbatch_write_line "$line"
    done
}

function wbatch_echo {
    wbatch_write_line "ECHO %time% $@"
}

#-------------------------------------------------------------------------------
# Batch function calls
#-------------------------------------------------------------------------------

function wbatch_abort_if_vm_exists {
    local vm_name=$1
    wbatch_write_line "CALL :vm_exists $vm_name"
}

function wbatch_wait_poweroff {
    local vm_name=$1
    cat << WBAT | wbatch_write_stdin
ECHO %time% Waiting for VM $vm_name to power off.
CALL :wait_poweroff $vm_name
ECHO %time% VM $vm_name powered off.
WBAT
}

function wbatch_wait_auto {
    cat << WBAT | wbatch_write_stdin
ECHO %time% Waiting for autostart files to execute.
CALL :wait_auto
ECHO %time% All autostart files executed.
WBAT
}

#-------------------------------------------------------------------------------
# Batch commands
#-------------------------------------------------------------------------------

function wbatch_delete_disk {
    local disk=$(basename "$1")
    wbatch_write_line "IF EXIST %IMGDIR%\\$disk DEL %IMGDIR%\\$disk"
}

function wbatch_rename_disk {
    local src=$(basename "$1")
    local target=$(basename "$2")

    wbatch_write_line "MOVE /y %IMGDIR%\\$src %IMGDIR%\\$target"
}

function wbatch_cp_auto {
    local src=$(wbatch_path_to_windows "$1")
    local target=$(basename "$2")
    src=${src//\//\\}
    wbatch_write_line "COPY %TOPDIR%\\$src %AUTODIR%\\$target"
}

function wbatch_sleep {
    local sec=$1
    wbatch_write_line "TIMEOUT /T $sec /NOBREAK"
}

#-------------------------------------------------------------------------------
# Templated parts
#-------------------------------------------------------------------------------

# Note: BSD and GNU sed behavior is different. Don't try anything fancy
#       like inserting \r or in-place editing (-i).

function wbatch_file_header {
    local product=$1

    sed -e "
        s,%PRODUCT%,$product,g;
        " "$WBATCH_TEMPLATE_DIR/template-file_header_bat" | wbatch_write_stdin
}

function wbatch_end_file {
    cat "$WBATCH_TEMPLATE_DIR/template-end_file_bat" | wbatch_write_stdin
    wbatch_close_file
}

function wbatch_elevate_privileges {
    cat "$WBATCH_TEMPLATE_DIR/template-elevate_privs_bat" | wbatch_write_stdin
}

function wbatch_find_vbm {
    cat "$WBATCH_TEMPLATE_DIR/template-find_vbm_bat" | wbatch_write_stdin
}

function wbatch_mkdirs {
    local autodir=$(wbatch_path_to_windows "$AUTOSTART_DIR")
    local imgdir=$(wbatch_path_to_windows "$IMG_DIR")
    local logdir=$(wbatch_path_to_windows "$LOG_DIR")
    local statusdir=$(wbatch_path_to_windows "$STATUS_DIR")

    autodir="$(wbatch_escape_backslash "$autodir")"
    imgdir="$(wbatch_escape_backslash "$imgdir")"
    logdir="$(wbatch_escape_backslash "$logdir")"
    statusdir="$(wbatch_escape_backslash "$statusdir")"

    sed -e "
        s,%P_AUTODIR%,$autodir,g;
        s,%P_IMGDIR%,$imgdir,g;
        s,%P_LOGDIR%,$logdir,g;
        s,%P_STATUSDIR%,$statusdir,g;
        " "$WBATCH_TEMPLATE_DIR/template-mkdirs_bat" | wbatch_write_stdin
}

function wbatch_create_hostnet {
    wbatch_new_file "create_hostnet.bat"
    wbatch_file_header "host-only networks"
    # Creating networks requires elevated privileges
    wbatch_elevate_privileges
    wbatch_find_vbm

    sed -e "
        s,%APINET%,$API_NET,g;
        s,%DATANET%,$DATA_NET,g;
        s,%MGMTNET%,$MGMT_NET,g;
        " "$WBATCH_TEMPLATE_DIR/template-create_hostnet_bat" | wbatch_write_stdin

    wbatch_end_file
}

function wbatch_begin_base {
    local iso_name=$(get_iso_name)

    if [ -z "$iso_name" ]; then
        echo >&2 "Windows batch file needs install ISO URL (ISO_URL)."
        exit 1
    fi

    wbatch_new_file "create_base.bat"
    wbatch_file_header "base disk"
    wbatch_find_vbm
    wbatch_mkdirs

    sed -e "
        s,%INSTALLFILE%,$iso_name,g;
        s,%ISOURL%,$ISO_URL,g;
        " "$WBATCH_TEMPLATE_DIR/template-begin_base_bat" | wbatch_write_stdin
}

function wbatch_begin_node {
    local node_name=$1
    wbatch_new_file "create_${node_name}_node.bat"
    wbatch_file_header "$node_name VM"
    wbatch_find_vbm
    wbatch_mkdirs

    local basedisk=$(basename "$BASE_DISK")

    sed -e "
        s,%BASEDISK%,$basedisk,g;
        " "$WBATCH_TEMPLATE_DIR/template-begin_node_bat" | wbatch_write_stdin
}

#-------------------------------------------------------------------------------
# VBoxManage call handling
#-------------------------------------------------------------------------------

function wbatch_get_hostif_subst {
    local hostif=$1
    case "$hostif" in
        ${MGMT_NET_IF:-""})
            echo 'VirtualBox Host-Only Ethernet Adapter'
            ;;
        ${DATA_NET_IF:-""})
            echo 'VirtualBox Host-Only Ethernet Adapter #2'
            ;;
        ${API_NET_IF:-""})
            echo 'VirtualBox Host-Only Ethernet Adapter #3'
            ;;
        *)
            return 1
            ;;
    esac
}

function wbatch_log_vbm {
    ARGS=( "$@" )
    for i in "${!ARGS[@]}"; do
        case "${ARGS[i]}" in
            --hostonlyadapter*)
                # The next arg is the host-only interface name -> change it
                ARGS[i+1]=\"$(wbatch_get_hostif_subst "${ARGS[i+1]}")\"
                ;;
            --hostpath)
                # The next arg is the shared dir -> change it
                ARGS[i+1]='%SHAREDIR%'
                continue
                ;;
        esac

        # On Windows, ISO and base disk images must be in IMGDIR
        re='\.(iso|vdi)$'
        if [[ "${ARGS[i]}" =~ $re ]]; then
            local img_name=$(basename "${ARGS[i]}")
            ARGS[i]="%IMGDIR%\\$img_name"
            continue
        fi
    done

    # Echo what we are about to do
    wbatch_write_line "ECHO VBoxManage ${ARGS[@]}"

    wbatch_write_line "VBoxManage ${ARGS[@]}"

    # Abort if VBoxManage call raised errorlevel
    wbatch_write_line "IF %errorlevel% NEQ 0 GOTO :vbm_error"

    # Blank line for readability
    wbatch_write_line ""
}

#-------------------------------------------------------------------------------
# Windows path name helpers
#-------------------------------------------------------------------------------

# On Windows, all paths are relative to TOP_DIR
function wbatch_path_to_windows {
    local full_path=$1
    # strip off ${TOP_DIR}/
    full_path="${full_path/$TOP_DIR\//}"
    full_path=$(wbatch_slash_to_backslash "$full_path")
    echo "$full_path"
}

# Escape backslashes in (path) variables that are given to sed
function wbatch_escape_backslash {
    local string=$1
    string="${string//\\/\\\\}"
    echo "$string"
}

function wbatch_slash_to_backslash {
    local some_path=$1
    some_path="${some_path//\//\\}"
    echo "$some_path"
}

# vim: set ai ts=4 sw=4 et ft=sh:
