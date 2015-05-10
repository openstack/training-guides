#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"
exec_logfile

indicate_current_auto

#------------------------------------------------------------------------------
# Set up OpenStack Dashboard (horizon)
# http://docs.openstack.org/juno/install-guide/install/apt/content/install_dashboard.html
#------------------------------------------------------------------------------

echo "Installing horizon."
sudo apt-get install -y openstack-dashboard apache2 libapache2-mod-wsgi \
    memcached python-memcache

echo "Purging Ubuntu theme."
sudo dpkg --purge openstack-dashboard-ubuntu-theme

function check_dashboard_settings {
    local dashboard_conf=/etc/openstack-dashboard/local_settings.py

    local auth_host=controller-mgmt
    echo "Setting OPENSTACK_HOST = \"$auth_host\"."
    sudo sed -i "s#^\(OPENSTACK_HOST =\).*#\1 \"$auth_host\";#" $dashboard_conf

    echo -n "Allowed hosts: "
    grep "^ALLOWED_HOSTS" $dashboard_conf

    local memcached_conf=/etc/memcached.conf
    # Port is a number on line starting with "-p "
    local port=$(grep -Po -- '(?<=^-p )\d+' $memcached_conf)

    # Interface is an IP address on line starting with "-l "
    local interface=$(grep -Po -- '(?<=^-l )[\d\.]+' $memcached_conf)

    echo "memcached listening on $interface:$port."

    # Line should read something like: 'LOCATION' : '127.0.0.1:11211',
    if grep "LOCATION.*$interface:$port" $dashboard_conf; then
        echo "$dashboard_conf agrees."
    else
        echo >&2 "$dashboard_conf disagrees. Aborting."
        exit 1
    fi

    echo -n "Time zone setting: "
    grep TIME_ZONE $dashboard_conf
}

echo "Checking dashboard configuration."
check_dashboard_settings

function check_apache_service {
    # Check if apache service is down, if not force retry a couple of times.
    sleep 10
    i=0
    until service apache2 status | grep 'not running'; do
        sudo service apache2 stop
        sleep 10
        i ++
        if [ $i -gt 3]
        then
            break
        fi
    done
}

echo "Reloading apache and memcached service."
sudo service apache2 stop
check_apache_service
sudo service memcached restart
