#!/usr/bin/env bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$LIB_DIR/functions.guest"

indicate_current_auto

exec_logfile

# Wait for removal of /tmp/remove_to_continue
wait_for_file
