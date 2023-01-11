#!/bin/bash

dir=$(dirname $(realpath $0))
all_synced=true
param=$1

TAIL="$(printf '\033[0m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"; BLUE="$(printf '\033[34m')"; WHITE="$(printf '\033[37m')"

file_list=(
    zshrc
    vimrc
)
extra_file_list=(
    coc_settings
)
zshrc_remote=$dir/.zshrc
zshrc_local=~/.zshrc
vimrc_remote=$dir/.vimrc
vimrc_local=~/.vimrc
coc_settings_remote=$dir/.config/nvim/coc-settings.json
coc_settings_local=~/.config/nvim/coc-settings.json

function cmd_parser
{
    case "$param" in
        a|-a) file_list=(${file_list[@]} ${extra_file_list[@]}) ;;
    esac
}

function check_editor
{
    if command -v nvim > /dev/null; then
        diff_command="nvim -d"
    elif command -v vim > /dev/null; then
        diff_command="vimdiff"
    else
        echo -e "${RED}No vim or neovim found on your device.\nAborting...${TAIL}"
        exit 1
    fi
}

function run_diff_all
{
    all_synced=true
    for file in ${file_list[@]}; do
        eval diff \$"${file}_remote" \$"${file}_local" > /dev/null
        if [ $? != 0 ]; then
            all_synced=false
        fi
    done
}

function run_edit
{
    run_diff_all
    if $all_synced; then
        echo -e "${GREEN}All files are the same.✔\nNothing to do.${TAIL}"
        exit
    fi

    for file in ${file_list[@]}; do
        eval diff \$"${file}_remote" \$"${file}_local" > /dev/null
        if [ $? != 0 ]; then
            read -s -n1 -p "$file unsynchronized. Edit with $diff_command ? [Y/n] " user_input
            if [ "$user_input" == "y" ] || [ "$user_input" == "" ]; then
                echo
                eval $diff_command \$"${file}_remote" \$"${file}_local"
                eval diff \$"${file}_remote" \$"${file}_local" > /dev/null
                if [ $? == 0 ]; then
                    echo "${GREEN}$file is now synced.✔${TAIL}"
                else
                    echo "${CYAN}$file is still unsynchronized."
                    echo "-- Use \`$diff_command $(eval echo \$${file}_remote \$${file}_local)\` later"
                    echo "-- or try to rerun this wizard${TAIL}"
                fi
            else
                echo -e "\n${YELLOW}$file is still unsynchronized. Aborting.${TAIL}"
            fi
        else
            echo "${GREEN}$file is already synced.✔${TAIL}"
        fi
    done

    run_diff_all
    if $all_synced; then
        echo "${GREEN}All files are same now.✔${TAIL}"
    fi
}

#main
cmd_parser
check_editor
run_edit
