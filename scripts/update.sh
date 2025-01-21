#!/usr/bin/env bash
#
# single command to update and sync all files
#
# should be linked by ~/.local/bin/csup using setup.sh
#

DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))
source $DIR/scripts/check_all.sh

function git_dirty() { [[ -n $(git -C $DIR status -u --porcelain) ]] ; }

function update_repo() {
    if ! check_all_files; then
        warning "There are inconsistent files.\nPlease run 'csc' to sync them first."
        exit 1
    fi

    if git_dirty; then
        warning "There are uncommitted changes in the repository.\nPlease commit or stash them first."
        exit 2
    fi
    git -C $DIR pull --rebase
}

function main() {
    cmd_parser "$@"
    add_extra_files
    declare_dirs
    update_repo
    run_edit
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
