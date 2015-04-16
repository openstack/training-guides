#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/openstack"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Install the Telemetry service
# http://docs.openstack.org/juno/install-guide/install/apt/content/ceilometer-nova.html
#------------------------------------------------------------------------------

echo "Installing ceilometer."
sudo apt-get install -y ceilometer-agent-compute

ceilometer_admin_user=$(service_to_user_name ceilometer)
ceilometer_admin_password=$(service_to_user_password ceilometer)

echo "Configuring ceilometer.conf."
conf=/etc/ceilometer/ceilometer.conf

iniset_sudo $conf publisher metering_secret "$METERING_SECRET"


# Configure RabbitMQ variables
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$ceilometer_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$ceilometer_admin_password"

iniset_sudo $conf service_credentials os_auth_url "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf service_credentials os_username "$ceilometer_admin_user"
iniset_sudo $conf service_credentials os_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf service_credentials os_password "$ceilometer_admin_password"
iniset_sudo $conf service_credentials os_endpoint_type internalURL
iniset_sudo $conf service_credentials os_region_name "$REGION"


iniset_sudo $conf DEFAULT verbose True

echo "Configuring nova.conf."
conf=/etc/ceilometer/ceilometer.conf

iniset_sudo $conf DEFAULT instance_usage_audit True
iniset_sudo $conf DEFAULT instance_usage_audit_period hour
iniset_sudo $conf DEFAULT notify_on_state_change vm_and_task_state
iniset_sudo $conf DEFAULT notification_driver messagingv2

echo "Restarting telemetry service."
sudo service ceilometer-agent-compute restart

echo "Restarting compute service."
sudo service nova-compute restart

#------------------------------------------------------------------------------
# Configure the Block Storage service(cinder-volume)
# http://docs.openstack.org/juno/install-guide/install/apt/content/ceilometer-cinder.html
#------------------------------------------------------------------------------

# Configure the Block Storage Service to send notifications to the message bus

echo "Configuring cinder.conf."
conf=/etc/cinder/cinder.conf

iniset_sudo $conf DEFAULT control_exchange cinder
iniset_sudo $conf DEFAULT notification_driver messagingv2

echo "Restarting cinder-volumes service."
sudo service cinder-volume restart

#------------------------------------------------------------------------------
# Verify the Telemetry installation
# http://docs.openstack.org/juno/install-guide/install/apt/content/ceilometer-verify.html
#------------------------------------------------------------------------------

echo "Verifying the telemetry installation."

AUTH="source $CONFIG_DIR/admin-openstackrc.sh"

echo "Waiting for ceilometer to start."
until node_ssh controller-mgmt "$AUTH; ceilometer meter-list" >/dev/null 2>&1; do
    sleep 1
done

echo "List available meters."
node_ssh controller-mgmt "$AUTH; ceilometer meter-list"

echo "Download an image from the Image Service."
img_name=$(basename "$CIRROS_URL" -disk.img)
node_ssh controller-mgmt "$AUTH; glance image-download \"$img_name\" > /tmp/cirros.img"

echo "List available meters again to validate detection of the image download."
node_ssh controller-mgmt "$AUTH; ceilometer meter-list"

echo "Retrieve usage statistics from the image.download meter."
node_ssh controller-mgmt "$AUTH; ceilometer statistics -m image.download -p 60"
