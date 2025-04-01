#!/usr/bin/env bash
#
# print recent commits from git log
#
# should be linked by ~/.local/bin/csl using setup.sh
#

DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))
source $DIR/scripts/check_all.sh

commit_count=8

function usage() {
    bold "Usage:"
    mesg "  $(realpath $0) [options]"
    mesg
    bold "Options:"
    mesg "  -n, --max-count  Number of commits to show (default: 8)"
    mesg "  -h, --help       Display help"
}

function cmd_parser() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            h | -h | --help)
                usage
                exit 0
                ;;
            n | -n | --max-count)
                if [[ "$2" =~ ^[0-9]+$ ]]; then
                    commit_count="$2"
                else
                    error "Error: Invalid value '$2'"
                    usage
                    exit 1
                fi
                ;;
            [0-9]*) commit_count="$1" ;;
            *)
                error "Error: Invalid option '$1'"
                usage
                exit 1
                ;;
        esac
        shift
    done
}

function print_commit_log() {
    git -C $DIR log \
        --reverse \
        --format="%C(blue)%h %C(green)(%ad) %C(white)%s" \
        --date=format-local:'%b %e %H:%M' \
        -n "$commit_count"
}

function main() {
    cmd_parser "$@"
    print_commit_log
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
