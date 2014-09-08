#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"
source "$CONFIG_DIR/admin-openstackrc.sh"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Create a normal user
#------------------------------------------------------------------------------

echo "Creating the demo user."
keystone user-create \
    --name="$DEMO_USER_NAME" \
    --pass="$DEMO_PASSWORD" \
    --email=demo@example.com

echo "Creating the demo tenant."
keystone tenant-create --name="$DEMO_TENANT_NAME" --description="Demo Tenant"

echo "Linking the demo user, _member_ role, and demo tenant."
keystone user-role-add \
    --user "$DEMO_USER_NAME" \
    --role _member_ \
    --tenant "$DEMO_TENANT_NAME"
