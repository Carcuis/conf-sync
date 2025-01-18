#!/usr/bin/env bash
#
# single command to sync all files
#
# should be linked by ~/.local/bin/csc using setup.sh
#

DIR=$(dirname $(dirname $(realpath $0)))
source $DIR/scripts/util.sh

verbose=""
force_sync=""

function usage() {
   bold "Usage:"
   mesg "  $(realpath $0) [options]"
   mesg
   bold "Options:"
   mesg "  -f, --force-sync Force sync files"
   mesg "  -h, --help       Display help"
   mesg "  -v, --verbose    Show detailed information"
}

function cmd_parser
{
    while [ "$#" -gt 0 ]; do
        case "$1" in
            h|-h|--help) usage; exit 0 ;;
            v|-v|--verbose) verbose="--verbose" ;;
            f|-f|--force-sync) force_sync="--force-sync" ;;
            *) error "Error: Invalid option '$1'"; usage; exit 1 ;;
        esac
        shift
    done
}

function check_all() {
    bash $DIR/check_consistency.sh --all $force_sync $verbose
}

function main() {
    cmd_parser "$@"
    check_all
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
