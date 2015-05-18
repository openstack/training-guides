# This file contains bash functions that may be used by both guest and host
# systems.

# Non-recursive removal of all files except README.*
function clean_dir {
    local target_dir=$1
    if [ ! -e "$target_dir" ]; then
        mkdir -pv "$target_dir"
    elif [ ! -d "$target_dir" ]; then
        echo >&2 "Not a directory: $target_dir"
        return 1
    fi
    shopt -s nullglob
    local entries=("$target_dir"/*)
    if [ -n "${entries[0]-}" ]; then
        for f in "${entries[@]}"; do
            # Skip directories
            if [ ! -f "$f" ]; then
                continue
            fi

            # Skip README.*
            if [[ $f =~ /README\. ]]; then
                continue
            fi

            rm -f "$f"
        done
    fi
}

function is_root {
    if [ $EUID -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

function yes_or_no {
    local prompt=$1
    local input=""
    while [ : ]; do
        read -p "$prompt (Y/n): " input
        case "$input" in
            N|n)
                return 1
                ;;
            ""|Y|y)
                return 0
                ;;
            *)
                echo -e "${CError:-}Invalid input: ${CData:-}$input${CReset:-}"
                ;;
        esac
    done
}

#-------------------------------------------------------------------------------
# Helpers to incrementally number files via name prefixes
#-------------------------------------------------------------------------------

function get_next_file_number {
    local dir=$1
    local ext=${2:-""}

    # Get number of *.log files in directory
    shopt -s nullglob
    if [ -n "$ext" ]; then
        # Count files with specific extension
        local files=("$dir/"*".$ext")
    else
        # Count all files
        local files=("$dir/"*)
    fi
    echo "${#files[*]}"
}

function get_next_prefix {
    local dir=$1
    local ext=$2
    # Number of digits in prefix string (default 3)
    local digits=${3:-3}

    # Get number of *.$ext files in $dir
    local cnt="$(get_next_file_number "$dir" "$ext")"

    printf "%0${digits}d" "$cnt"
}

# vim: set ai ts=4 sw=4 et ft=sh:
