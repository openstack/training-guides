#!/bin/bash
set -o errexit -o nounset
TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)
source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/deploy.osbash"
source "$CONFIG_DIR/provider.virtualbox"
source "$OSBASH_LIB_DIR/functions-host.sh"
source "$OSBASH_LIB_DIR/virtualbox-functions.sh"

OSBASH=exec_cmd

LOG_NAME=test.log
RESULTS_ROOT=$LOG_DIR/test-results

CONTROLLER_SNAPSHOT="controller_node_installed"
TEST_SCRIPT=$TOP_DIR/scripts/test/launch_instance.sh

VERBOSE=${VERBOSE:=1}

function usage {
    echo "Usage: $0 {-b|-c|-t <SNAP>} [-s '<NODES>']"
    echo ""
    echo "-h        Help"
    echo "-c        Restore node VMs to current snapshot for each test"
    echo "-t SNAP   Restore cluster to target snapshot for each test"
    echo "-s NODES  Start each named node VM after restoring the cluster"
    echo "-b        Rebuild cluster for each test, from scratch or snapshot"
    echo "          (osbash.sh -b cluster [...])"
}

while getopts :bchs:t: opt; do
    case $opt in
        b)
            REBUILD=yes
            ;;
        c)
            CURRENT=yes
            ;;
        h)
            usage
            exit 0
            ;;
        s)
            START_VMS=$OPTARG
            ;;
        t)
            TARGET_SNAPSHOT=$OPTARG
            if ! "$TOP_DIR/tools/restore-cluster.sh" -l |
                    grep -q "Name: $TARGET_SNAPSHOT "; then
                echo >&2 "No snapshot named $TARGET_SNAPSHOT found."
                exit 1
            fi
            ;;
        :)
            echo "Error: -$OPTARG needs argument"
            ;;
        ?)
            echo "Error: invalid option -$OPTARG"
            echo
            usage
            exit 1
            ;;
    esac
done

if [ -z "${REBUILD:-}" -a -z "${CURRENT:-}" -a -z "${TARGET_SNAPSHOT:-}" ]; then
    usage
    exit 1
fi

# Remove processed options from arguments
shift $(( OPTIND - 1 ));

mkdir -p "$RESULTS_ROOT"

while [ : ]; do
    dir_name=$(get_next_prefix "$RESULTS_ROOT" "")
    echo "Starting test $dir_name."
    dir=$RESULTS_ROOT/$dir_name
    mkdir -p "$dir"

    (
    cd "$TOP_DIR"

    if [ -n "${TARGET_SNAPSHOT:-}" ]; then
        "$TOP_DIR/tools/restore-cluster.sh" -t "$TARGET_SNAPSHOT"
        if [ -n "${START_VMS:-}" ]; then
            # Start VMs as requested by user
            for vm_name in $START_VMS; do
                echo >&2 "$0: booting node $vm_name."
                vbox_boot "$vm_name"
                # Sleeping for 10 s fixes some problems, but it might be
                # better to fix client scripts to wait for the services they
                # need instead of just failing.
            done
        fi
    fi

    if [ -n "${REBUILD:-}" ]; then
        if [ -n "${TARGET_SNAPSHOT:-}" ]; then
            "$TOP_DIR/osbash.sh" -t "$TARGET_SNAPSHOT" -b cluster
        else
            "$TOP_DIR/osbash.sh" -b cluster
        fi
    fi

    echo "Running test. Log file: $dir/$LOG_NAME"
    rc=0
    TEST_ONCE=$TOP_DIR/tools/test-once.sh
    if [ "${VERBOSE:-}" -eq 1 ]; then
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

    echo "Copying osbash log files into $dir."
    mv "$LOG_DIR/"*.auto "$LOG_DIR/"*.log "$dir"

    echo "Copying upstart log files into $dir."
    "$TOP_DIR/tools/get_upstart_logs.sh" "$dir"
done
