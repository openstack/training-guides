#!/usr/bin/env bash
set -o errexit -o nounset
# This script is the first to run and the only one to run as root.

# XXX The name activate_autostart.sh is hard-coded in ks.cfg and preseed.cfg.

# Remove files that called us (written by {ks,preseed}.cfg)
rm -f /etc/init.d/osbash /etc/rc2.d/S40osbash

TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
# source_deploy doesn't work here
source "$CONFIG_DIR/deploy.osbash"
source "$LIB_DIR/functions.guest"

readonly RCAUTOSTART=osbashauto

indicate_current_auto

# This guest script doesn't write to $HOME; the log file's extension is .auto
exec_logfile "$LOG_DIR" "auto"

# Some guest additions leave a broken symlink /sbin/mount.vboxsf
as_root_fix_mount_vboxsf_link

if ! id -u "$VM_SHELL_USER" >/dev/null 2>&1; then
    # User doesn't exist -> add
    useradd osbash -G vboxsf
    echo "$VM_SHELL_USER:$VM_SHELL_USER" | chpasswd
elif ! id -Gn "$VM_SHELL_USER" >/dev/null 2>&1 | grep -q vboxsf; then
    # User isn't in group vboxsf -> add
    usermod -a -G vboxsf "$VM_SHELL_USER"
fi

as_root_inject_sudoer

if [ ! -f "$OSBASH_SCRIPTS_DIR/template-$RCAUTOSTART" ]; then
    echo "Template not found: $OSBASH_SCRIPTS_DIR/template-$RCAUTOSTART"
    exit 1
fi

# LOG_DIR and SHARE_DIR are based on the temporary mount point /media/sf_*
# which won't be there after reboot; use new paths for osbashauto

NLOG_DIR="/$SHARE_NAME/$(basename "$LOG_DIR")"

sed -e "
    s,%SHARE_NAME%,$SHARE_NAME,g;
    s,%VM_SHELL_USER%,$VM_SHELL_USER,g;
    s,%NLOG_DIR%,$NLOG_DIR,g;
    s,%RCAUTOSTART%,$RCAUTOSTART,g;
    " "$OSBASH_SCRIPTS_DIR/template-$RCAUTOSTART" > "/etc/init.d/$RCAUTOSTART"

chmod 755 "/etc/init.d/$RCAUTOSTART"

# Make devstack's is_fedora work with nounset
init_os_ident

if is_fedora; then
    cat << SERVICE > /etc/systemd/system/$RCAUTOSTART.service
[Unit]
Description=OpenStack autostart
Requires=vboxadd-service.service
After=vboxadd-service.service vboxadd.service

[Service]
ExecStart=/etc/init.d/$RCAUTOSTART

[Install]
WantedBy=multi-user.target
SERVICE

    systemctl enable "$RCAUTOSTART.service"
    systemctl start "$RCAUTOSTART.service"
else
    ln -s "../init.d/$RCAUTOSTART" "/etc/rc2.d/S99$RCAUTOSTART"
fi
