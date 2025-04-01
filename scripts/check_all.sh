#!/usr/bin/env bash
#
# single command to sync all files
#
# should be linked by ~/.local/bin/csc using setup.sh
#

DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))
source $DIR/check_consistency.sh

function add_extra_files() {
    file_list+=( ${extra_file_list[@]} )
}

function usage() {
    bold "Usage:"
    mesg "  $(realpath $0) [options]"
    mesg
    bold "Options:"
    mesg "  -f, --force-sync Force sync files"
    mesg "  -h, --help       Display help"
    mesg "  -v, --verbose    Show detailed information"
}

function cmd_parser() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            h|-h|--help) usage; exit 0 ;;
            v|-v|--verbose) verbose=true ;;
            f|-f|--force-sync) make_sync_force ;;
            *) error "Error: Invalid option '$1'"; usage; exit 1 ;;
        esac
        shift
    done
}

function main() {
    cmd_parser "$@"
    add_extra_files
    declare_dirs
    run_edit
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
