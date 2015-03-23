#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Install the Image Service (glance).
# http://docs.openstack.org/juno/install-guide/install/apt/content/glance-install.html
#------------------------------------------------------------------------------

echo "Setting up database for glance."
setup_database glance

echo "Sourcing the admin credentials."
source "$CONFIG_DIR/admin-openstackrc.sh"

glance_admin_user=$(service_to_user_name glance)
glance_admin_password=$(service_to_user_password glance)

echo "Creating glance user and giving it admin role under service tenant."
keystone user-create \
    --name "$glance_admin_user" \
    --pass "$glance_admin_password" \

keystone user-role-add \
    --user "$glance_admin_user" \
    --tenant "$SERVICE_TENANT_NAME" \
    --role "$ADMIN_ROLE_NAME"

echo "Registering glance with keystone so that other services can locate it."
keystone service-create \
    --name glance \
    --type image \
    --description "OpenStack Image Service"

glance_service_id=$(keystone service-list | awk '/ image / {print $2}')
keystone endpoint-create \
    --service-id "$glance_service_id" \
    --publicurl "http://controller-api:9292" \
    --internalurl "http://controller-mgmt:9292" \
    --adminurl "http://controller-mgmt:9292" \
    --region "$REGION"

echo "Installing glance."
sudo apt-get install -y glance python-glanceclient

function get_database_url {
    local db_user=$(service_to_db_user glance)
    local db_password=$(service_to_db_password glance)
    local database_host=controller-mgmt

    echo "mysql://$db_user:$db_password@$database_host/glance"
}

database_url=$(get_database_url)
echo "Database connection: $database_url."

echo "Configuring glance-api.conf."
conf=/etc/glance/glance-api.conf
iniset_sudo $conf database connection "$database_url"
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$glance_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$glance_admin_password"
iniset_sudo $conf paste_deploy flavor "keystone"
iniset_sudo $conf glance_store default_store file
iniset_sudo $conf glance_store filesystem_store_datadir /var/lib/glance/images/
iniset_sudo $conf DEFAULT verbose True

echo "Configuring glance-registry.conf."
conf=/etc/glance/glance-registry.conf
iniset_sudo $conf database connection "$database_url"
iniset_sudo $conf keystone_authtoken auth_uri "http://controller-mgmt:5000/v2.0"
iniset_sudo $conf keystone_authtoken identity_uri "http://controller-mgmt:35357"
iniset_sudo $conf keystone_authtoken admin_tenant_name "$SERVICE_TENANT_NAME"
iniset_sudo $conf keystone_authtoken admin_user "$glance_admin_user"
iniset_sudo $conf keystone_authtoken admin_password "$glance_admin_password"
iniset_sudo $conf paste_deploy flavor "keystone"
iniset_sudo $conf DEFAULT verbose True

echo "Creating the database tables for glance."
sudo glance-manage db_sync

echo "Restarting glance service."
sudo service glance-registry restart
sudo service glance-api restart

echo "Removing default SQLite database."
sudo rm -f /var/lib/glance/glance.sqlite

#------------------------------------------------------------------------------
# Verify the Image Service installation
# http://docs.openstack.org/juno/install-guide/install/apt/content/glance-verify.html
#------------------------------------------------------------------------------

echo "Waiting for glance to start."
until glance image-list >/dev/null 2>&1; do
    sleep 1
done

# cirros-0.3.3-x86_64-disk.img -> cirros-0.3.3-x86_64
img_name=$(basename $CIRROS_URL -disk.img)

echo "Adding CirrOS image as $img_name to glance."

glance image-create \
    --name "$img_name" \
    --file "$HOME/img/$(basename $CIRROS_URL)" \
    --disk-format qcow2 \
    --container-format bare \
    --is-public True

echo "Verifying that the image was successfully added to the service."

echo "glance image-list"
glance image-list
