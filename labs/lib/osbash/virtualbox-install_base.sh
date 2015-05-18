# This bash library contains the main function that creates the base disk.

function check_md5 {
    local file=$1
    local csum=$2
    local md5exe
    if ! md5exe=$(which md5sum); then
        # On Mac OS X, the tool is called md5
        if ! md5exe=$(which md5); then
            echo -e >&2 "${CError:-}Neither md5sum nor md5 found. Aborting.${CReset:-}"
            exit 1
        fi
    fi
    echo -e >&2 -n "${CStatus:-}Verifying ISO image MD5 checksum: ${CReset:-}"
    if $md5exe "$file" | grep -q "$csum"; then
        echo >&2 "okay."
    else
        echo -e >&2 "${CError:-}Verification failed. ISO image is corrupt.${CReset:-}"
        echo >&2 "Removing the ISO image."
        rm "$file"
        echo -e >&2 "${CError:-}Please re-run osbash script.${CReset:-}"
        exit 1
    fi
}

function vm_install_base {
    local base_disk=$1
    local base_build_disk=$DISK_DIR/tmp-disk.vdi
    local vm_name=base

    # Port used for ssh forwarding when building base disk
    : ${VM_BASE_SSH_PORT:=2229}

    echo >&2 "$(date) osbash vm_install starts."

    ${WBATCH:-:} wbatch_begin_base

    # Don't remove base_build_disk if we are just faking it for wbatch
    ${OSBASH:-:} rm -f "$base_build_disk"
    ${WBATCH:-:} wbatch_delete_disk "$base_build_disk"

    vm_create "$vm_name"
    vm_mem "$vm_name" "${VM_BASE_MEM:=512}"

    if [ -z "${INSTALL_ISO-}" ]; then
        local iso_name="$(get_iso_name)"

        if [  -z "$iso_name" ]; then
            echo -e >&2 "${CMissing:-}Either ISO URL or name needed (ISO_URL, INSTALL_ISO).${CReset:-}"
            exit 1
        fi
        INSTALL_ISO=$ISO_DIR/$iso_name
        # Don't look for ISO image if we are only doing wbatch
        ${OSBASH:-:} find_install-iso "$iso_name"
    fi

    echo >&2 -e "${CInfo:-}Install ISO:\n\t${CData:-}$INSTALL_ISO${CReset:-}"

    ${OSBASH:-:} check_md5 "$INSTALL_ISO" "$ISO_MD5"

    $VBM storageattach "$vm_name" \
        --storagectl IDE \
        --port 0 \
        --device 0 \
        --type dvddrive \
        --medium "$INSTALL_ISO"

    ${WBATCH:-:} vm_attach_guestadd-iso "$vm_name"

    ${OSBASH:-:} mkdir -pv "$DISK_DIR"
    create_vdi "$base_build_disk" "${BASE_DISK_SIZE:=10000}"
    vm_attach_disk "$vm_name" "$base_build_disk"

    #---------------------------------------------------------------------------
    # Set up communication with base VM: ssh port forwarding by default,
    # VirtualBox shared folders for wbatch

    # wbatch runs cannot use ssh, so skip port forwarding in that case
    ${WBATCH:+:} vm_port "$vm_name" ssh "$VM_BASE_SSH_PORT" 22

    # Automounted on /media/sf_bootstrap for first boot
    ${WBATCH:-:} vm_add_share_automount "$vm_name" "$SHARE_DIR" bootstrap
    # Mounted on /$SHARE_NAME after first boot
    ${WBATCH:-:} vm_add_share "$vm_name" "$SHARE_DIR" "$SHARE_NAME"
    #---------------------------------------------------------------------------

    $VBM modifyvm "$vm_name" --boot1 dvd

    # Configure autostart
    autostart_reset

    # For wbatch, install osbashauto as a boot service
    ${WBATCH:-:} autostart osbash/activate_autostart.sh

    autostart osbash/base_fixups.sh

    # By default, set by lib/osbash/lib.* to something like scripts.ubuntu_base
    autostart_from_config "$BASE_INSTALL_SCRIPTS"

    autostart zero_empty.sh shutdown.sh

    # Boot VM into distribution installer
    vbox_boot "$vm_name"

    local delay=5
    echo >&2 "Waiting $delay seconds for VM \"$vm_name\" to come up"
    vbox_sleep "$delay"

    vbox_distro_start_installer "$vm_name"

    echo -e >&2 "${CStatus:-}Installing operating system; waiting for reboot${CReset:-}"

    # Wait for ssh connection and execute scripts in autostart directory
    # (for wbatch, osbashauto does the processing instead)
    ${WBATCH:+:} ssh_process_autostart "$VM_BASE_SSH_PORT" &
    # After reboot
    wait_for_autofiles
    echo -e >&2 "${CStatus:-}Installation done for VM ${CData:-}$vm_name${CReset:-}"

    vm_wait_for_shutdown "$vm_name"

    # Detach disk from VM now or it will be deleted by vm_unregister_del
    vm_detach_disk "$vm_name"

    vm_unregister_del "$vm_name"

    echo >&2 "Compacting $base_build_disk"
    $VBM modifyhd "$base_build_disk" --compact

    # This disk will be moved to a new name, and this name will be used for
    # a new disk next time the script runs.
    disk_unregister "$base_build_disk"

    echo -e >&2 "${CStatus:-}Base disk created${CReset:-}"

    echo >&2 "Moving base disk to $base_disk"
    ${OSBASH:-:} mv -vf "$base_build_disk" "$base_disk"
    ${WBATCH:-:} wbatch_rename_disk "$base_build_disk" "$base_disk"

    ${WBATCH:-:} wbatch_end_file

    echo >&2 -e "${CData:-}$(date) ${CStatus:-}osbash vm_install ends\n${CReset:-}"
}

# vim: set ai ts=4 sw=4 et ft=sh:
