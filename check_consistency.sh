#!/usr/bin/env bash

dir=$(dirname $(realpath $0))
params=$@

TAIL="$(printf '\033[0m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"; BLUE="$(printf '\033[34m')"; WHITE="$(printf '\033[37m')"

function detect_system() {
    local _uname_a=$(uname -a)

    if [[ $_uname_a =~ Microsoft ]]; then SYSTEM="WSL1"
    elif [[ $_uname_a =~ WSL2 ]];    then SYSTEM="WSL2"
    elif [[ $OSTYPE =~ ^darwin ]];   then SYSTEM="Darwin"
    elif [[ $OSTYPE =~ android ]];   then SYSTEM="Android"
    elif [[ $OSTYPE =~ ^linux ]];    then SYSTEM="Linux"
    else SYSTEM="Unknown"
    fi
}
detect_system

file_list=(
    zshrc
    vimrc
)
extra_file_list=(
    coc_settings
    ptpython_config
    lazygit_config
    git_config
    vifmrc
)

zshrc_remote=$dir/.zshrc
zshrc_local=~/.zshrc
vimrc_remote=$dir/.vimrc
vimrc_local=~/.vimrc
coc_settings_remote=$dir/.config/nvim/coc-settings.json
coc_settings_local=~/.config/nvim/coc-settings.json
ptpython_config_remote=$dir/.config/ptpython/config.py
lazygit_config_remote=$dir/.config/lazygit/config.yml
if [ "$SYSTEM" == "Darwin" ]; then
    ptpython_config_local="$HOME/Library/Application Support/ptpython/config.py"
    lazygit_config_local="$HOME/Library/Application Support/lazygit/config.yml"
else
    ptpython_config_local=~/.config/ptpython/config.py
    lazygit_config_local=~/.config/lazygit/config.yml
fi
ideavimrc_remote=$dir/dot_files/.ideavimrc
ideavimrc_local=~/.ideavimrc
git_config_remote=$dir/dot_files/.gitconfig
git_config_local=~/.gitconfig
kitty_config_remote=$dir/.config/kitty/kitty.conf
kitty_config_local=~/.config/kitty/kitty.conf
vifmrc_remote=$dir/.config/vifm/vifmrc
vifmrc_local=~/.config/vifm/vifmrc

function cmd_parser
{
    case ${params[0]} in
        a|-a)
            case $SYSTEM in
                WSL*|Android) ideavimrc=""; echo "${CYAN}Skipped ideavimrc on current system: $SYSTEM ✔${TAIL}" ;;
                *) ideavimrc=ideavimrc ;;
            esac
            case $SYSTEM in
                Android) kitty_config=""; echo "${CYAN}Skipped kitty config on current system: $SYSTEM ✔${TAIL}" ;;
                *) kitty_config=kitty_config ;;
            esac
            file_list=(${file_list[@]} ${extra_file_list[@]} $ideavimrc $kitty_config) ;;
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
    for file in ${file_list[@]}; do
        local file_remote=$(eval echo \$${file}_remote)
        local file_local=$(eval echo \$${file}_local)

        if [ ! -f "$file_local" ]; then
            return 1
        fi

        if ! diff "$file_remote" "$file_local" > /dev/null; then
            return 1
        fi
    done
    return
}

function run_edit
{
    if run_diff_all; then
        echo -e "${GREEN}All files are the same.✔\nNothing to do.${TAIL}"
        return
    fi

    for file in ${file_list[@]}; do
        local file_remote=$(eval echo \$${file}_remote)
        local file_local=$(eval echo \$${file}_local)

        if [ ! -f "$file_local" ]; then
            local file_local_dir=$(dirname "$file_local")
            read -n1 -p "$file not found, create a copy to \`$file_local\` ? [Y/n] " user_input </dev/tty
            if [ "$user_input" == "" ]; then user_input=y; else echo; fi
            if [ "$user_input" == "y" ]; then
                [ ! -d "$file_local_dir" ] && mkdir -p "$file_local_dir"
                cp "$file_remote" "$file_local"
                echo "${GREEN}Copied \`$file_remote\` to \`$file_local\`.✔${TAIL}"
            else
                echo "${YELLOW}Abort.${TAIL}"
            fi
            continue
        fi

        if ! diff "$file_remote" "$file_local" > /dev/null; then
            read -n1 -p "$file unsynchronized. Edit with $diff_command ? [Y/n] " user_input </dev/tty
            if [ "$user_input" == "" ]; then user_input=y; else echo; fi
            if [ "$user_input" == "y" ]; then
                $diff_command "$file_remote" "$file_local"
                if diff "$file_remote" "$file_local" > /dev/null; then
                    echo "${GREEN}$file is now synced.✔${TAIL}"
                else
                    echo "${CYAN}$file is still unsynchronized."
                    echo "-- Use \`$diff_command \"$file_remote\" \"$file_local\"\` later,"
                    echo "-- or try to rerun this script.${TAIL}"
                fi
            else
                echo "${YELLOW}$file is still unsynchronized. Aborting.${TAIL}"
            fi
        else
            echo "${GREEN}$file is already synced.✔${TAIL}"
        fi
    done

    if run_diff_all; then
        echo "${GREEN}All files are same now.✔${TAIL}"
    fi
}

#main
cmd_parser
check_editor
run_edit
