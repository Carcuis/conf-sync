#!/usr/bin/env sh

old=$(echo "$2" | sed 's|\\|/|g')
new=$(echo "$5" | sed 's|\\|/|g')
path="$1"
git diff --no-index --no-ext-diff "$old" "$new" |
    sed -e "s|$old|$path|g" -e "s|$new|$path|g" |
    delta --width="${LAZYGIT_COLUMNS}" --no-gitconfig --line-numbers --tabs=4 --dark --paging=never --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
