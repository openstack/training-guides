# The variables in this file are exported for use by OpenStack client
# applications.

# Unlike a regular openstackrc.sh file, this file gets its variable values
# from other configuration files (to limit redundancy).

# Use BASH_SOURCE so the file works when sourced from a shell, too
CONFIG_DIR=$(dirname "$BASH_SOURCE")
source "$CONFIG_DIR/openstack"
source "$CONFIG_DIR/credentials"

export OS_USERNAME=$DEMO_USER_NAME
export OS_PASSWORD=$DEMO_PASSWORD
export OS_TENANT_NAME=$DEMO_TENANT_NAME
export OS_AUTH_URL="http://controller-mgmt:5000/v2.0"
