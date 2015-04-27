#-------------------------------------------------------------------------------
# VirtualBoxManage
#-------------------------------------------------------------------------------

VBM=vbm
: ${VBM_LOG:=$LOG_DIR/vbm.log}

# vbm is a wrapper around the VirtualBox VBoxManage executable; it handles
# logging and conditional execution (set OSBASH= to prevent the actual call to
# VBoxManage, or WBATCH= to keep a call from being recorded for Windows batch
# files)
function vbm {
    ${WBATCH:-:} wbatch_log_vbm "$@"

    mkdir -p "$(dirname "$VBM_LOG")"

    if [[ -n "${OSBASH:-}" ]]; then
        echo "$@" >> "$VBM_LOG"
        local rc=0
        "$VBM_EXE" "$@" || rc=$?
        if [ $rc -ne 0 ]; then
            echo -e >&2 "${CError:-}FAILURE: VBoxManage: $@${CReset:-}"
            return 1
        fi
    else
        echo "(not executed) $@" >> "$VBM_LOG"
    fi
}

# Return VirtualBox version string (without distro extensions)
function get_vb_version {
    local version=""
    # e.g. 4.1.32r92798 4.3.10_RPMFusionr93012 4.3.10_Debianr93012
    local raw=$(WBATCH= $VBM --version)
    # Sanitize version string
    local re='([0-9]+\.[0-9]+\.[0-9]+).*'
    if [[ $raw =~ $re ]]; then
        version=${BASH_REMATCH[1]}
    fi
    echo "$version"
}

#-------------------------------------------------------------------------------
# VM status
#-------------------------------------------------------------------------------

function vm_exists {
    local vm_name=$1
    return $(WBATCH= $VBM list vms | grep -q "\"$vm_name\"")
}

function vm_is_running {
    local vm_name=$1
    return $(WBATCH= $VBM showvminfo --machinereadable "$vm_name" | \
        grep -q 'VMState="running"')
}

function vm_wait_for_shutdown {
    local vm_name=$1

    ${WBATCH:-:} wbatch_wait_poweroff "$vm_name"
    # Return if we are just faking it for wbatch
    ${OSBASH:+:} return 0

    echo -e >&2 -n "${CStatus:-}Machine shutting down${CReset:-}"
    until WBATCH= $VBM showvminfo --machinereadable "$vm_name" 2>/dev/null | \
            grep -q '="poweroff"'; do
        echo -n .
        sleep 1
    done
    echo >&2 -e "${CStatus:-}\nMachine powered off.${CReset:-}"
}

function vm_power_off {
    local vm_name=$1
    if vm_is_running "$vm_name"; then
        echo -e >&2 "${CStatus:-}Powering off VM ${CData:-}\"$vm_name\"${CReset:-}"
        $VBM controlvm "$vm_name" poweroff
    fi
    # VirtualBox VM needs a break before taking new commands
    vbox_sleep 1
}

function vm_snapshot {
    local vm_name=$1
    local shot_name=$2

    $VBM snapshot "$vm_name" take "$shot_name"
    # VirtualBox VM needs a break before taking new commands
    vbox_sleep 1
}

#-------------------------------------------------------------------------------
# Host-only network functions
#-------------------------------------------------------------------------------

function hostonlyif_in_use {
    local if_name=$1
    return $(WBATCH= $VBM list -l runningvms | \
        grep -q "Host-only Interface '$if_name'")
}

function ip_to_hostonlyif {
    local ip=$1
    local prevline=""
    WBATCH= $VBM list hostonlyifs | grep -e "^Name:" -e "^IPAddress:" | \
    while read line; do
        if [[ "$line" == *$ip* ]]; then
            # match longest string that ends with a space
            echo ${prevline##Name:* }
            break
        fi
        prevline=$line
    done
}

function create_hostonlyif {
    local out=$(WBATCH= $VBM hostonlyif create 2> /dev/null | grep "^Interface")
    # out is something like "Interface 'vboxnet3' was successfully created"
    local re="Interface '(.*)' was successfully created"
    if [[ $out =~ $re ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo -e >&2 "${CError:-}Host-only interface creation failed${CReset:-}"
        return 1
    fi
}

function create_network {
    local ip=$1

    # If we are here only for wbatch, ignore actual network interfaces; just
    # return a unique identifier (so it can be replaced with the interface
    # name used by Windows).
    ${OSBASH:+:} mktemp -u XXXXXXXX
    ${OSBASH:+:} return 0

    local if_name="$(ip_to_hostonlyif "$ip")"
    if [ -n "$if_name" ]; then
        if hostonlyif_in_use "$if_name"; then
            echo >&2 "Host-only interface $if_name ($ip) is in use." \
                        "Using it, too."
        fi
    else
        echo -e >&2 "${CStatus:-}Creating host-only interface${CReset:-}"
        if_name=$(create_hostonlyif)
    fi

    echo -e >&2 "${CStatus:-}Configuring host-only network ${CData:-}$ip ($if_name)${CReset:-}"
    $VBM hostonlyif ipconfig "$if_name" \
        --ip "$ip" \
        --netmask 255.255.255.0 >/dev/null
    echo "$if_name"
}

#-------------------------------------------------------------------------------
# Disk functions
#-------------------------------------------------------------------------------

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Creating, registering and unregistering disk images with VirtualBox
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# disk can be either a path or a disk UUID
function disk_registered {
    local disk=$1
    return $(WBATCH= $VBM list hdds | grep -q "$disk")
}

# disk can be either a path or a disk UUID
function disk_unregister {
    local disk=$1
    echo >&2 -e "${CStatus:-}Unregistering disk\n\t${CData:-}$disk${CReset:-}"
    $VBM closemedium disk "$disk"
}

function create_vdi {
    local hd_path=$1
    local size=$2
    echo >&2 -e "${CStatus:-}Creating disk:\n\t${CData:-}$hd_path${CReset:-}"
    $VBM createhd --format VDI --filename "$hd_path" --size "$size"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Attaching and detaching disks from VMs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# disk can be either a path or a disk UUID
function get_next_child_uuid {
    local disk=$1
    local child_uuid=""
    local line=""
    if disk_registered "$disk"; then
        line=$(WBATCH= $VBM showhdinfo "$disk" | grep -e "^Child UUIDs:")
        child_uuid=${line##Child UUIDs:* }
    fi
    echo -e "next_child_uuid $disk:\n\t$line\n\t$child_uuid" >> "$VBM_LOG"
    echo "$child_uuid"
}

# disk can be either a path or a disk UUID
function path_to_disk_uuid {
    local disk=$1
    local uuid=""
    local line=$(WBATCH= $VBM showhdinfo "$disk" | grep -e "^UUID:")
    local re='UUID:[ ]+([^ ]+)'
    if [[ $line =~ $re ]]; then
        uuid=${BASH_REMATCH[1]}
    fi
    echo -e "path_to_disk_uuid $disk:\n\t$line\n\t$uuid" >> "$VBM_LOG"
    echo "$uuid"
}

# disk can be either a path or a disk UUID
function disk_to_path {
    local disk=$1
    local fpath=""
    local line=$(WBATCH= $VBM showhdinfo "$disk" | grep -e "^Location:")
    local re='Location:[ ]+([^ ]+)'
    if [[ $line =~ $re ]]; then
        fpath=${BASH_REMATCH[1]}
    fi
    echo -e "disk_to_path $disk:\n\t$line\n\t$fpath" >> "$VBM_LOG"
    echo "$fpath"
}

# disk can be either a path or a disk UUID
function disk_to_vm {
    local disk=$1
    local vm_name=""
    local line=$(WBATCH= $VBM showhdinfo "$disk" | grep -e "^In use by VMs:")
    local re='In use by VMs:[ ]+([^ ]+) '
    if [[ $line =~ $re ]]; then
        vm_name=${BASH_REMATCH[1]}
    fi
    echo -e "disk_to_vm $disk:\n\t$line\n\t$vm_name" >> "$VBM_LOG"
    echo "$vm_name"
}

function vm_get_disk_path {
    local vm_name=$1
    local line=$(WBATCH= $VBM showvminfo --machinereadable "$vm_name" | \
        grep '^"SATA-0-0"=.*vdi"$')
    local hd_path=${line##\"SATA-0-0\"=\"}
    hd_path=${hd_path%\"}
    echo "$hd_path"
}

function vm_detach_disk {
    local vm_name=$1
    echo >&2 "Detaching disk from VM \"$vm_name\""
    $VBM storageattach "$vm_name" \
        --storagectl SATA \
        --port 0 \
        --device 0 \
        --type hdd \
        --medium none
    # VirtualBox VM needs a break before taking new commands
    vbox_sleep 1
}

# disk can be either a path or a disk UUID
function vm_attach_disk {
    local vm_name=$1
    local disk=$2
    echo >&2 -e "Attaching to VM \"$vm_name\":\n\t$disk"
    $VBM storageattach "$vm_name" \
        --storagectl SATA \
        --port 0 \
        --device 0 \
        --type hdd \
        --medium "$disk"
}

# disk can be either a path or a disk UUID
function vm_attach_disk_multi {
    local vm_name=$1
    local disk=$2

    $VBM modifyhd --type multiattach "$disk"

    echo >&2 -e "Attaching to VM \"$vm_name\":\n\t$disk"
    $VBM storageattach "$vm_name" \
        --storagectl SATA \
        --port 0 \
        --device 0 \
        --type hdd \
        --medium "$disk"
}

#-------------------------------------------------------------------------------
# VM create and configure
#-------------------------------------------------------------------------------

function vm_mem {
    local vm_name="$1"
    local mem="$2"
    $VBM modifyvm "$vm_name" --memory "$mem"
}

function vm_cpus {
    local vm_name="$1"
    local cpus="$2"
    $VBM modifyvm "$vm_name" --cpus "$cpus"
}

# Port forwarding from host to VM (binding to host's 127.0.0.1)
function vm_port {
    local vm_name="$1"
    local desc="$2"
    local hostport="$3"
    local guestport="$4"
    $VBM modifyvm "$vm_name" \
        --natpf1 "$desc,tcp,127.0.0.1,$hostport,,$guestport"
}

function vm_nic_hostonly {
    local vm_name=$1
    # We start counting interfaces at 0, but VirtualBox starts NICs at 1
    local nic=$(($2 + 1))
    local net_name=$3
    $VBM modifyvm "$vm_name" \
        "--nictype$nic" "$NICTYPE" \
        "--nic$nic" hostonly \
        "--hostonlyadapter$nic" "$net_name" \
        "--nicpromisc$nic" allow-all
}

function vm_nic_nat {
    local vm_name=$1
    # We start counting interfaces at 0, but VirtualBox starts NICs at 1
    local nic=$(($2 + 1))
    $VBM modifyvm "$vm_name" "--nictype$nic" "$NICTYPE" "--nic$nic" nat
}

function vm_create {
    # NOTE: We assume that a VM with a matching name is ours.
    #       Remove and recreate just in case someone messed with it.
    local vm_name=$1

    ${WBATCH:-:} wbatch_abort_if_vm_exists "$vm_name"

    # Don't write to wbatch scripts, and don't execute when we are faking it
    # it for wbatch
    WBATCH= ${OSBASH:-:} vm_delete "$vm_name"

    # XXX ostype is distro-specific; moving it to modifyvm disables networking

    # Note: The VirtualBox GUI may not notice group changes after VM creation
    #       until GUI is restarted. Moving a VM with group membership will
    #       fail in cases (lingering files from old VM) where creating a
    #       VM in that location succeeds.
    #
    # XXX temporary hack
    # --groups not supported in VirtualBox 4.1 (Mac OS X 10.5)
    echo -e >&2 "${CStatus:-}Creating VM ${CData:-}\"$vm_name\"${CReset:-}"
    local ver=$(get_vb_version)
    if [[ $ver = 4.1*  ]]; then
        $VBM createvm \
            --name "$vm_name" \
            --register \
            --ostype Ubuntu_64 >/dev/null
    else
        $VBM createvm \
            --name "$vm_name" \
            --register \
            --ostype Ubuntu_64 \
            --groups "/$VM_GROUP"  >/dev/null
    fi

    $VBM modifyvm "$vm_name" --rtcuseutc on
    $VBM modifyvm "$vm_name" --biosbootmenu disabled
    $VBM modifyvm "$vm_name" --largepages on
    $VBM modifyvm "$vm_name" --boot1 disk

    # XXX temporary hack
    # --portcount not supported in VirtualBox 4.1 (Mac OS X 10.5)
    if [[ $ver == 4.1*  ]]; then
        $VBM storagectl "$vm_name" --name SATA --add sata
    else
        $VBM storagectl "$vm_name" --name SATA --add sata --portcount 1
    fi
    $VBM storagectl "$vm_name" --name SATA --hostiocache on

    $VBM storagectl "$vm_name" --name IDE --add ide
    echo -e >&2 "${CStatus:-}Created VM ${CData:-}\"$vm_name\"${CReset:-}"
}

#-------------------------------------------------------------------------------
# VM export
#-------------------------------------------------------------------------------

# Export node VMs to OVA package file
function vm_export_ova {
    local ova_file=$1
    local nodes=$2
    echo >&2 "Removing shared folders for export"
    local -a share_paths
    local node
    for node in $nodes; do
        local share_path=$(vm_get_share_path "$node")
        share_paths+=("$share_path")
        if [ -n "$share_path" ]; then
            vm_rm_share "$node" "$SHARE_NAME"
        fi
    done
    rm -f "$ova_file"
    mkdir -pv "$IMG_DIR"
    $VBM export $nodes --output "$ova_file"
    echo >&2 "Appliance exported"
    echo >&2 "Reattaching shared folders"
    local ii=0
    for node in $nodes; do
        if [ -n "${share_paths[$ii]}" ]; then
            vm_add_share "$node" "${share_paths[$ii]}" "$SHARE_NAME"
        fi
        ii=$(($ii + 1))
    done
}

# Export node VMs by cloning VMs to directory
function vm_export_dir {
    local export_dir=$1
    local nodes=$2

    rm -rvf "$export_dir"

    for node in $nodes; do
        if vm_is_running "$node"; then
            echo "Powering off node VM $node."
            echo "$VBM controlvm $node poweroff"
            $VBM controlvm "$node" poweroff
        fi
        sleep 1
        local share_path=$(vm_get_share_path "$node")
        if [ -n "$share_path" ]; then
            echo >&2 "Removing shared folder for export"
            vm_rm_share "$node" "$SHARE_NAME"
        fi
        sleep 1
        echo "Exporting VM $node to $export_dir"
        # Use all: machineandchildren works only if --snapshot is given as UUID
        $VBM clonevm "$node" \
            --mode all \
            --options keepallmacs,keepdisknames \
            --name "$node-e" \
            --groups "/$VM_GROUP" \
            --basefolder "$export_dir" \
            --register
        # VirtualBox registers disks and snapshots of the clone VM even if we
        # don't register the VM above. Unregistering the registered VM takes
        # care of the snapshots, but we still have to unregister the clone
        # basedisk.
        local snapshot_path="$(vm_get_disk_path "$node-e")"
        local hd_dir=${snapshot_path%Snapshots/*}
        local hd_path=$hd_dir$(get_base_disk_name)
        $VBM unregistervm "$node-e"
        if [ -n "$hd_path" ]; then
            disk_unregister "$hd_path"
        fi
        if [ -n "$share_path" ]; then
            echo >&2 "Reattaching shared folder"
            vm_add_share "$node" "$share_path" "$SHARE_NAME"
        fi
    done
}

#-------------------------------------------------------------------------------
# VM unregister, remove, delete
#-------------------------------------------------------------------------------

function vm_unregister_del {
    local vm_name=$1
    echo -e >&2 "${CStatus:-}Unregistering and deleting VM ${CData:-}\"$vm_name\"${CReset:-}"
    $VBM unregistervm "$vm_name" --delete
}

function vm_delete {
    local vm_name=$1
    echo >&2 -n "Asked to delete VM \"$vm_name\" "
    if vm_exists "$vm_name"; then
        echo >&2 "(found)"
        vm_power_off "$vm_name"
        local hd_path="$(vm_get_disk_path "$vm_name")"
        if [ -n "$hd_path" ]; then
            echo >&2 -e "${CInfo:-}Disk attached: ${CData:-}$hd_path${CReset:-}"
            vm_detach_disk "$vm_name"
            disk_unregister "$hd_path"
            echo >&2 -e "Deleting: $hd_path"
            rm -f "$hd_path"
        fi
        vm_unregister_del "$vm_name"
    else
        echo >&2 "(not found)"
    fi
}

# Remove VMs using disk and its children disks
# disk can be either a path or a disk UUID
function disk_delete_child_vms {
    local disk=$1
    if ! disk_registered "$disk"; then
        # VirtualBox doesn't know this disk; we are done
        echo >&2 -e "${CError:-}Disk not registered with VirtualBox:\n\t${CData:-}$disk${CReset:-}"
        return 0
    fi

    # XXX temporary hack
    # No Child UUIDs through showhdinfo in VirtualBox 4.1 (Mac OS X 10.5)
    local ver=$(get_vb_version)
    if [[ $ver == 4.1*  ]]; then
        local vm_name=""
        for vm_name in controller network compute base; do
            vm_delete "$vm_name"
        done
        return 0
    fi

    while [ : ]; do
        local child_uuid=$(get_next_child_uuid "$disk")
        if [ -n "$child_uuid" ]; then
            local child_disk="$(disk_to_path "$child_uuid")"
            echo >&2 -e "\nChild disk UUID: $child_uuid\n\t$child_disk"

            local vm_name="$(disk_to_vm "$child_uuid")"
            if [ -n "$vm_name" ]; then
                echo 2>&1 -e "\tstill attached to VM \"$vm_name\""
                vm_delete "$vm_name"
            else
                echo -e >&2 "${CStatus:-}Unregistering and deleting: ${CData:-}$child_uuid${CReset:-}"
                disk_unregister "$child_uuid"
                echo >&2 -e "\t$child_disk"
                rm -f "$child_disk"
            fi
        else
            break
        fi
    done
}

#-------------------------------------------------------------------------------
# VM shared folders
#-------------------------------------------------------------------------------

# Return the host path for a VM's shared directory; assumes there is only one.
function vm_get_share_path {
    local vm_name=$1
    local line=$(WBATCH= $VBM showvminfo --machinereadable "$vm_name" | \
        grep '^SharedFolderPathMachineMapping1=')
    local share_path=${line##SharedFolderPathMachineMapping1=\"}
    share_path=${share_path%\"}
    echo "$share_path"
}

function vm_add_share_automount {
    local vm_name=$1
    local share_dir=$2
    local share_name=$3
    $VBM sharedfolder add "$vm_name" \
        --name "$share_name" \
        --hostpath "$share_dir" \
        --automount
}

function vm_add_share {
    local vm_name=$1
    local share_dir=$2
    local share_name=$3
    $VBM sharedfolder add "$vm_name" \
        --name "$share_name" \
        --hostpath "$share_dir"
}

function vm_rm_share {
    local vm_name=$1
    local share_name=$2
    $VBM sharedfolder remove "$vm_name" --name "$share_name"
}

#-------------------------------------------------------------------------------
# VirtualBox guest add-ons
#-------------------------------------------------------------------------------

# Download VirtualBox guest-additions. Returns local path of ISO image.
function _download_guestadd-iso {
    local iso=VBoxGuestAdditions.iso
    local ver=$(get_vb_version)
    if [[ -n "$ver" ]]; then
        local url="http://download.virtualbox.org/virtualbox/$ver/VBoxGuestAdditions_$ver.iso"
        download "$url" "$ISO_DIR" $iso
    fi
    echo "$ISO_DIR/$iso"
}

function _get_guestadd-iso {
    local iso=VBoxGuestAdditions.iso

    local add_iso="$IMG_DIR/$iso"
    if [ -f "$add_iso" ]; then
        echo "$add_iso"
        return 0
    fi

    add_iso="/Applications/VirtualBox.app/Contents/MacOS/$iso"
    if [ -f "$add_iso" ]; then
        echo "$add_iso"
        return 0
    fi

    echo >&2 "Searching filesystem for VBoxGuestAdditions. This may take a while..."
    add_iso=$(find / -name "$iso" 2>/dev/null) || true
    if [ -n "$add_iso" ]; then
        echo "$add_iso"
        return 0
    fi

    echo >&2 "Looking on the Internet"
    add_iso=$(_download_guestadd-iso)
    if [ -f "$add_iso" ]; then
        echo "$add_iso"
        return 0
    fi
}

function _vm_attach_guestadd-iso {
    local vm_name=$1
    local guestadd_iso=$2
    local rc=0
    $VBM storageattach "$vm_name" --storagectl IDE --port 1 --device 0 --type dvddrive --medium "$guestadd_iso" 2>/dev/null || rc=$?
    return $rc
}

function vm_attach_guestadd-iso {
    local vm_name=$1

    OSBASH= ${WBATCH:-:} _vm_attach_guestadd-iso "$vm_name" emptydrive
    OSBASH= ${WBATCH:-:} _vm_attach_guestadd-iso "$vm_name" additions
    # Return if we are just faking it for wbatch
    ${OSBASH:+:} return 0

    if [ -z "${GUESTADD_ISO-}" ]; then

        # No location provided, asking VirtualBox for one

        # An existing drive is needed to make additions shortcut work
        # (at least VirtualBox 4.3.12 and below)
        WBATCH= _vm_attach_guestadd-iso "$vm_name" emptydrive

        if WBATCH= _vm_attach_guestadd-iso "$vm_name" additions; then
            echo >&2 "Using VBoxGuestAdditions provided by VirtualBox"
            return 0
        fi
        # Neither user nor VirtualBox are helping, let's go guessing
        GUESTADD_ISO=$(_get_guestadd-iso)
        if [ -z "GUESTADD_ISO" ]; then
            # No ISO found
            return 2
        fi
    fi
    if WBATCH= _vm_attach_guestadd-iso "$vm_name" "$GUESTADD_ISO"; then
        echo >&2 "Attached $GUESTADD_ISO"
        return 0
    else
        echo -e >&2 "${CError:-}Failed to attach ${CData:-}$GUESTADD_ISO${CReset:-}"
        return 3
    fi
}

#-------------------------------------------------------------------------------
# Sleep
#-------------------------------------------------------------------------------

function vbox_sleep {
    sec=$1

    # Don't sleep if we are just faking it for wbatch
    ${OSBASH:-:} sleep "$sec"
    ${WBATCH:-:} wbatch_sleep "$sec"
}

#-------------------------------------------------------------------------------
# Booting a VM and passing boot parameters
#-------------------------------------------------------------------------------

source "$OSBASH_LIB_DIR/scanlib.sh"

function _vbox_push_scancode {
    local vm_name=$1
    shift
    # Split string (e.g. '01 81') into arguments (works also if we
    # get each hexbyte as a separate argument)
    # Not quoting $@ is intentional -- we want to split on blanks
    local scan_code=( $@ )
    $VBM controlvm "$vm_name" keyboardputscancode "${scan_code[@]}"
}

function vbox_kbd_escape_key {
    local vm_name=$1
    _vbox_push_scancode "$vm_name" "$(esc2scancode)"
}

function vbox_kbd_enter_key {
    local vm_name=$1
    _vbox_push_scancode "$vm_name" "$(enter2scancode)"
}

function vbox_kbd_string_input {
    local vm_name=$1
    local str=$2

    # This loop is inefficient enough that we don't overrun the keyboard input
    # buffer when pushing scancodes to the VirtualBox.
    while IFS=  read -r -n1 char; do
        if [ -n "$char" ]; then
            SC=$(char2scancode "$char")
            if [ -n "$SC" ]; then
                _vbox_push_scancode "$vm_name" "$SC"
            else
                echo >&2 "not found: $char"
            fi
        fi
    done <<< "$str"
}

function vbox_boot {
    local vm_name=$1

    echo -e >&2 "${CStatus:-}Starting VM ${CData:-}\"$vm_name\"${CReset:-}"
    if [ -n "${VM_UI:-}" ]; then
        $VBM startvm "$vm_name" --type "$VM_UI"
    else
        $VBM startvm "$vm_name"
    fi
}

#-------------------------------------------------------------------------------

# vim: set ai ts=4 sw=4 et ft=sh:
