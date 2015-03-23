#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/credentials"
source "$LIB_DIR/functions.guest"

exec_logfile

indicate_current_auto

#-------------------------------------------------------------------------------
# Install the message broker service (RabbitMQ).

echo "Installing RabbitMQ."
sudo apt-get install -y rabbitmq-server

echo "Setting RabbitMQ password to '$RABBIT_PASSWORD'."
sudo rabbitmqctl change_password guest "$RABBIT_PASSWORD"
