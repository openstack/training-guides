# This bash library contains the main function that creates a node VM.

# Configure VirtualBox network interfaces
function _vbox_configure_ifs {
    local vm_name=$1
    # Iterate over all NET_IF_? variables
    local net_ifs=( "${!NET_IF_@}" )
    local net_if=""
    for net_if in "${net_ifs[@]}"; do
        local if_num=${net_if##*_}
        if [ "${!net_if}" = "nat" ]; then
            echo "interface $if_num: NAT"
            vm_nic_nat "$vm_name" "$if_num"
        else
            # Host-only network: net_if is net name (e.g. API_NET)
            # Use corresponding VirtualBox interface (e.g. API_NET_IF)
            local host_if="${!net_if}_IF"
            echo "interface $if_num: host-only ${!host_if}"
            vm_nic_hostonly "$vm_name" "$if_num" "${!host_if}"
        fi
    done
}

# Boot node VM; wait until autostart files are processed and VM is shut down
function _vbox_boot_with_autostart {
    local vm_name=$1

    vbox_boot "$vm_name"

    # Wait for ssh connection and execute scripts in autostart directory
    # (for wbatch, osbashauto does the processing instead)
    ${WBATCH:+:} ssh_process_autostart "$vm_name" &

    wait_for_autofiles
    echo >&2 "VM \"$vm_name\": autostart files executed"
}

# Create a new node VM and run basic configuration scripts
function vm_init_node {
    # XXX Run this function in sub-shell to protect our caller's environment
    #     (which might be _our_ enviroment if we get called again)
    (
    source "$CONFIG_DIR/config.$vm_name"

    vm_name=$1

    vm_create "$vm_name"

    # Set VM_MEM in config/config.NODE_NAME to override
    vm_mem "$vm_name" "${VM_MEM:-512}"

    # Set VM_CPUS in config/config.NODE_NAME to override
    vm_cpus "$vm_name" "${VM_CPUS:-1}"

    _vbox_configure_ifs "$vm_name"

    # Port forwarding
    if [ -n "${VM_SSH_PORT:-}" ]; then
        vm_port "$vm_name" ssh "$VM_SSH_PORT" 22
    fi
    if [ -n "${VM_WWW_PORT:-}" ]; then
        vm_port "$vm_name" http "$VM_WWW_PORT" 80
    fi

    vm_add_share "$vm_name" "$SHARE_DIR" "$SHARE_NAME"
    vm_attach_disk_multi "$vm_name" "$BASE_DISK"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Rename to pass the node name to the script
    autostart_and_rename osbash init_xxx_node.sh "init_${vm_name}_node.sh"

    )
}

function vm_build_nodes {
    CONFIG_NAME=$(get_distro_name "$DISTRO")_$1
    echo -e "${CInfo:-}Configuration file: ${CData:-}$CONFIG_NAME${CReset:-}"

    ${WBATCH:-:} wbatch_begin_node "$CONFIG_NAME"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    autostart_reset
    autostart_from_config "scripts.$CONFIG_NAME"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ${WBATCH:-:} wbatch_end_file
}

# vim: set ai ts=4 sw=4 et ft=sh:
