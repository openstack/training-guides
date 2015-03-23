#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

#-------------------------------------------------------------------------------
# Controller setup

# Get FOURTH_OCTET for this node
source "$CONFIG_DIR/config.$(hostname)"

# Get MGMT_NET
source "$CONFIG_DIR/openstack"

DB_IP=$(get_ip_from_net_and_fourth "MGMT_NET" "$FOURTH_OCTET")
echo "Will bind MySQL server to $DB_IP."

echo "Sourced MySQL password from credentials: $DATABASE_PASSWORD"
sudo debconf-set-selections  <<< 'mysql-server mysql-server/root_password password '$DATABASE_PASSWORD''
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '$DATABASE_PASSWORD''

echo "Installing MySQL."
sudo apt-get install -y mysql-server python-mysqldb

echo "Configuring MySQL to accept requests by other nodes."

# Enable access by other nodes via the management network
iniset_sudo /etc/mysql/my.cnf mysqld bind-address "$DB_IP"

# Enable InnoDB
iniset_sudo /etc/mysql/my.cnf mysqld default-storage-engine innodb
iniset_sudo /etc/mysql/my.cnf mysqld innodb_file_per_table 1

# Enable UTF-8 character set and UTF-8 collation by default
iniset_sudo /etc/mysql/my.cnf mysqld collation-server utf8_general_ci
iniset_sudo /etc/mysql/my.cnf mysqld init-connect "'SET NAMES utf8'"
iniset_sudo /etc/mysql/my.cnf mysqld character-set-server utf8

echo "Restarting MySQL service."
sudo service mysql restart

# TODO(rluethi) do we need mysql_secure_installation?
# XXX --use-default only in MySQL 5.7.4+ (Ubuntu 12.04 LTS: MySQL 5.5)
# mysql_secure_installation --use-default
