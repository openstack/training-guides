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
# http://docs.openstack.org/juno/install-guide/install/apt/content/ceilometer-controller-install.html
#------------------------------------------------------------------------------

echo "Setting up database for telemetry."

echo "Installing the MongoDB packages."
sudo apt-get install -y mongodb-server mongodb-clients python-pymongo

echo "Configuring mongodb.conf."
conf=/etc/mongodb.conf
iniset_sudo_no_section $conf bind_ip "$(hostname_to_ip controller-mgmt)"
iniset_sudo_no_section $conf smallfiles true

echo "Restarting mongodb."
sudo service mongodb restart

echo "Waiting for mongodb to start."
while sudo service mongodb status 2>/dev/null | grep "stop"; do
    sleep 5
    echo -n .
done

ceilometer_admin_user=$(service_to_user_name ceilometer)
ceilometer_admin_password=$(service_to_user_password ceilometer)

mongodb_user=$(service_to_db_user ceilometer)
mongodb_password=$(service_to_db_password ceilometer)

echo "Creating the ceilometer database."
mongo --host "$(hostname_to_ip controller-mgmt)" --eval "
    db = db.getSiblingDB(\"ceilometer\");
    db.addUser({user: \"${mongodb_user}\",
    pwd: \"${mongodb_password}\",
    roles: [ \"readWrite\", \"dbAdmin\" ]})"

echo "Sourcing the admin credentials."
source "$CONFIG_DIR/admin-openstackrc.sh"

echo "Creating ceilometer user and giving it admin role under service tenant."
keystone user-create \
    --name "$ceilometer_admin_user" \
    --pass "$ceilometer_admin_password" \

keystone user-role-add \
    --user "$ceilometer_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Registering ceilometer with keystone so that other services can locate it."
keystone service-create \
    --name ceilometer \
    --type metering \
    --description "Telemetry"

ceilometer_service_id=$(keystone service-list | awk '/ metering / {print $2}')
keystone endpoint-create \
    --service-id "$ceilometer_service_id" \
    --publicurl "http://controller-api:8777" \
    --internalurl "http://controller-mgmt:8777" \
    --adminurl "http://controller-mgmt:8777" \
    --region "$REGION"

echo "Installing ceilometer."
sudo apt-get install -y ceilometer-api ceilometer-collector \
                        ceilometer-agent-central \
                        ceilometer-agent-notification \
                        ceilometer-alarm-evaluator \
                        ceilometer-alarm-notifier \
                        python-ceilometerclient

function get_database_url {
    local db_user=$(service_to_db_user ceilometer)
    local db_password=$(service_to_db_password ceilometer)
    local database_host=controller-mgmt

    echo "mongodb://$db_user:$db_password@$database_host:27017/ceilometer"
}

database_url=$(get_database_url)
echo "Database connection: $database_url."

echo "Configuring ceilometer.conf."
conf=/etc/ceilometer/ceilometer.conf
iniset_sudo $conf database connection "$database_url"

# Configure RabbitMQ variables
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

# Configure the [DEFAULT] section
iniset_sudo $conf DEFAULT auth_strategy keystone

iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$ceilometer_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$ceilometer_admin_password"

iniset_sudo $conf service_credentials os_auth_url "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf service_credentials os_username "$ceilometer_admin_user"
iniset_sudo $conf service_credentials os_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf service_credentials os_password "$ceilometer_admin_password"

iniset_sudo $conf publisher metering_secret "$METERING_SECRET"

iniset_sudo $conf DEFAULT verbose True


echo "Restarting telemetry service."
sudo service ceilometer-agent-central restart
sudo service ceilometer-agent-notification restart
sudo service ceilometer-api restart
sudo service ceilometer-collector restart
sudo service ceilometer-alarm-evaluator restart
sudo service ceilometer-alarm-notifier restart

#------------------------------------------------------------------------------
# Configure the Image service
# http://docs.openstack.org/juno/install-guide/install/apt/content/ceilometer-glance.html
#------------------------------------------------------------------------------

# Configure the Image Service to send notifications to the message bus

echo "Configuring glance-api.conf."
conf=/etc/glance/glance-api.conf

iniset_sudo $conf DEFAULT notification_driver messagingv2
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

echo "Configuring glance-registry.conf."
conf=/etc/glance/glance-registry.conf

iniset_sudo $conf DEFAULT notification_driver messagingv2
iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"

sudo service glance-registry restart
sudo service glance-api restart

#------------------------------------------------------------------------------
# Configure the Block Storage service
# http://docs.openstack.org/juno/install-guide/install/apt/content/ceilometer-cinder.html
#------------------------------------------------------------------------------

# Configure the Block Storage Service to send notifications to the message bus

echo "Configuring cinder.conf."
conf=/etc/cinder/cinder.conf

iniset_sudo $conf DEFAULT control_exchange cinder
iniset_sudo $conf DEFAULT notification_driver messagingv2

echo "Restarting cinder services."
sudo service cinder-api restart
sudo service cinder-scheduler restart
