#!/usr/bin/env bash
#
# open lazygit in conf-sync directory
#
# should be linked by ~/.local/bin/csg using setup.sh
#

DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))
source $DIR/scripts/util.sh

function usage() {
    bold "Usage:"
    mesg "  $(realpath $0) [options]"
    mesg
    bold "Options:"
    mesg "  -h, --help       Display help"
}

function cmd_parser() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            h | -h | --help)
                usage
                exit 0
                ;;
            *)
                error "Error: Invalid option '$1'"
                usage
                exit 1
                ;;
        esac
    done
}

function open_lazygit() {
    if ! has_command lazygit; then
        error "Error: 'lazygit' command not found"
        exit 1
    fi

    lazygit -p "$DIR"
}

function main() {
    cmd_parser "$@"
    open_lazygit
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
