#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0")/.. && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

#-------------------------------------------------------------------------------
# Create database Keystone, Glance, Neutron, Nova, and Cinder
#-------------------------------------------------------------------------------
function mysql_exe {
    local CMD="$1"
    echo mysql -u "root" -p"$DATABASE_PASSWORD" -e "$CMD"
}

function setup_database {
    local DB=$1
    mysql_exe "CREATE DATABASE $DB"
    mysql_exe "GRANT ALL ON ${DB}.* TO '${DB}User'@'%' IDENTIFIED BY '${DB}Pass';"
}

setup_database keystone
setup_database glance
setup_database neutron
setup_database nova
setup_database cinder

