#!/usr/bin/env bash
#
# single command to update and sync all files
#
# should be linked by ~/.local/bin/csup using setup.sh
#

DIR=$(dirname $(dirname $(realpath $0)))
source $DIR/scripts/check_all.sh

function git_dirty() { [[ -n $(git -C $DIR status -u --porcelain) ]] ; }

function update() {
    if git_dirty; then
        warning "There are uncommitted changes in the repository. Please commit or stash them first."
        exit 1
    fi
    git -C $DIR pull --rebase

    check_all
}

function main() {
    cmd_parser "$@"
    update
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
