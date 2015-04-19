#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Install the Orchestration Service (heat).
# http://docs.openstack.org/juno/install-guide/install/apt/content/heat-install-controller-node.html
#------------------------------------------------------------------------------

echo "Setting up database for heat."
setup_database heat

echo "Sourcing the admin credentials."
source "$CONFIG_DIR/admin-openstackrc.sh"

heat_admin_user=$(service_to_user_name heat)
heat_admin_password=$(service_to_user_password heat)

echo "Creating heat user and giving it admin role under service tenant."
keystone user-create \
    --name "$heat_admin_user" \
    --pass "$heat_admin_password" \

keystone user-role-add \
    --user "$heat_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Creating the heat stack owner role."
keystone role-create --name "heat_stack_owner"

keystone user-role-add \
    --user "$DEMO_USER_NAME" \
    --tenant "$DEMO_TENANT_NAME" \
    --role heat_stack_owner

echo "Creating the heat stack user role."
keystone role-create --name "heat_stack_user"

echo "Registering heat with keystone so that other services can locate it."
keystone service-create \
    --name heat \
    --type orchestration \
    --description "Orchestration"

keystone service-create \
    --name heat-cfn \
    --type cloudformation \
    --description "Orchestration"


heat_service_id=$(keystone service-list | awk '/ orchestration / {print $2}')
keystone endpoint-create \
    --service-id "$heat_service_id" \
    --publicurl "http://controller-api:8004/v1/%(tenant_id)s" \
    --internalurl "http://controller-mgmt:8004/v1/%(tenant_id)s" \
    --adminurl "http://controller-mgmt:8004/v1/%(tenant_id)s" \
    --region "$REGION"

heatcfn_service_id=$(keystone service-list | awk '/ cloudformation / {print $2}')
keystone endpoint-create \
    --service-id "$heatcfn_service_id" \
    --publicurl "http://controller-api:8000/v1" \
    --internalurl "http://controller-mgmt:8000/v1" \
    --adminurl "http://controller-mgmt:8000/v1" \
    --region "$REGION"


echo "Installing heat."
sudo apt-get install -y heat-api heat-api-cfn heat-engine \
    python-heatclient

function get_database_url {
    local db_user=$(service_to_db_user heat)
    local db_password=$(service_to_db_password heat)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/heat"
}

database_url=$(get_database_url)
echo "Database connection: $database_url."

echo "Configuring heat.conf."
conf=/etc/heat/heat.conf
iniset_sudo $conf database connection "$database_url"

echo "Configuring [DEFAULT] section in /etc/heat/heat.conf."

iniset_sudo $conf DEFAULT rpc_backend rabbit
iniset_sudo $conf DEFAULT rabbit_host controller-mgmt
iniset_sudo $conf DEFAULT rabbit_password "$RABBIT_PASSWORD"


iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$heat_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$heat_admin_password"
iniset_sudo $conf ec2authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf DEFAULT heat_metadata_server_url "http://controller-mgmt:8000"
iniset_sudo $conf DEFAULT heat_waitcondition_server_url "http://controller-mgmt:8000/v1/waitcondition"
iniset_sudo $conf DEFAULT verbose True


echo "Creating the database tables for heat."
sudo heat-manage db_sync

echo "Restarting heat service."
sudo service heat-api restart
sudo service heat-api-cfn restart
sudo service heat-engine restart

echo "Removing default SQLite database."
sudo rm -f /var/lib/heat/heat.sqlite
