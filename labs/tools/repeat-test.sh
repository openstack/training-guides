#!/bin/bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/deploy.osbash"
source "$OSBASH_LIB_DIR/functions-host.sh"

LOG_NAME=test.log
RESULTS_ROOT=$LOG_DIR/test-results

CONTROLLER_SNAPSHOT="controller_node_installed"
TEST_SCRIPT=$TOP_DIR/scripts/test/launch_instance.sh

VERBOSE=${VERBOSE:=1}

function usage {
    echo "Usage: $0 {rebuild|restore}"
    echo "       rebuild: rebuild cluster for each test (osbash.sh -b cluster)"
    echo "       restore: restore cluster for each test (cluster-restore.sh)"
    exit 1
}

if [ $# = 0 ]; then
    usage
elif [ "$1" = "rebuild" ]; then
    INIT=rebuild
elif [ "$1" = "restore" ]; then
    unset INIT
else
    usage
fi

mkdir -p "$RESULTS_ROOT"

while [ : ]; do
    dir_name=$(get_next_prefix "$RESULTS_ROOT" "")
    echo "Starting test $dir_name."
    dir=$RESULTS_ROOT/$dir_name
    mkdir -p "$dir"

    (
    cd "$TOP_DIR"

    if [ "${INIT:=""}" = "rebuild" ]; then
        echo "Building cluster."
        "$TOP_DIR/osbash.sh" -b cluster
    else
        echo "Restoring cluster."
        "$TOP_DIR/tools/restore-cluster.sh" "$CONTROLLER_SNAPSHOT"
    fi

    echo "Running test. Log file: $dir/$LOG_NAME"
    rc=0
    TEST_ONCE=$TOP_DIR/tools/test-once.sh
    if [ "$VERBOSE" -eq 1 ]; then
        "$TEST_ONCE" "$TEST_SCRIPT" 2>&1 | tee "$dir/$LOG_NAME" || rc=$?
    else
        "$TEST_ONCE" "$TEST_SCRIPT" > "$dir/$LOG_NAME" 2>&1 || rc=$?
    fi

    if [ $rc -eq 0 ]; then
        echo "Test done."
    else
        echo "Failed to run test. Aborting."
        exit 1
    fi
    )

    "$TOP_DIR/tools/get_upstart_logs.sh" "$dir"
done
