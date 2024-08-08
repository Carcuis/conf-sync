#!/usr/bin/env bash

DIR=$(dirname $(realpath $0))
verbose=false

BOLD="$(printf '\033[1m')"; TAIL="$(printf '\033[0m')"; WHITE="$(printf '\033[37m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"; CYAN="$(printf '\033[36m')"

function mesg()     { echo -e "${WHITE}$1${TAIL}" ; }
function info()     { if [[ $verbose == true ]]; then mesg "${CYAN}$1"; fi ; }
function bold()     { mesg "${BOLD}$1" ; }
function success()  { bold "${GREEN}$1 ✔" ; }
function warning()  { bold "${YELLOW}$1" ; }
function error()    { bold "${RED}$1" 1>&2 ; }

declare -a file_list=(
    zshrc
    vimrc
)
declare -a extra_file_list=(
    coc_settings
    ptpython_config
    lazygit_config
    ideavimrc
    git_config
    shellcheckrc
    kitty_config
    vifmrc
)

# shellcheck disable=SC2034
function declare_dirs() {
    zshrc_remote=$DIR/.zshrc
    zshrc_local=$HOME/.zshrc
    vimrc_remote=$DIR/.vimrc
    vimrc_local=$HOME/.vimrc
    coc_settings_remote=$DIR/.config/nvim/coc-settings.json
    coc_settings_local=$HOME/.config/nvim/coc-settings.json
    ptpython_config_remote=$DIR/.config/ptpython/config.py
    ptpython_config_local=$HOME/.config/ptpython/config.py
    lazygit_config_remote=$DIR/.config/lazygit/config.yml
    lazygit_config_local=$HOME/.config/lazygit/config.yml
    ideavimrc_remote=$DIR/dot_files/.ideavimrc
    ideavimrc_local=$HOME/.ideavimrc
    git_config_remote=$DIR/dot_files/.gitconfig
    git_config_local=$HOME/.gitconfig
    shellcheckrc_remote=$DIR/dot_files/.shellcheckrc
    shellcheckrc_local=$HOME/.shellcheckrc
    kitty_config_remote=$DIR/.config/kitty/kitty.conf
    kitty_config_local=$HOME/.config/kitty/kitty.conf
    vifmrc_remote=$DIR/.config/vifm/vifmrc
    vifmrc_local=$HOME/.config/vifm/vifmrc

    case $SYSTEM in
        Darwin)
            ptpython_config_local="$HOME/Library/Application Support/ptpython/config.py"
            lazygit_config_local="$HOME/Library/Application Support/lazygit/config.yml"
            ;;
    esac

    local -a exclude_file_list

    case $SYSTEM in
        Android) exclude_file_list+=( ideavimrc kitty_config ) ;;
        WSL*)    exclude_file_list+=( ideavimrc ) ;;
    esac

    if [[ ${#exclude_file_list[@]} != 0 ]]; then
        for exclude_file in ${exclude_file_list[@]}; do
            file_list=( ${file_list[@]/$exclude_file} )
        done
        info "Skipped ${exclude_file_list[*]} on current system: ${GREEN}$SYSTEM ✔"
    fi
}

function usage() {
   bold "Usage:"
   mesg "  check_consistency.sh [options]"
   mesg
   bold "Options:"
   mesg "  -a, --all        Check all files"
   mesg "  -h, --help       Display help"
   mesg "  -v, --verbose    Show detailed information"
}

function cmd_parser
{
    while [ "$#" -gt 0 ]; do
        case "$1" in
            a|-a|--all) file_list+=( ${extra_file_list[@]} ) ;;
            h|-h|--help) usage; exit 0 ;;
            v|-v|--verbose) verbose=true ;;
            *) error "Error: Invalid option '$1'"; usage; exit 1 ;;
        esac
        shift
    done
}

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

function has_command() { command -v "$1" > /dev/null ; }
function has_dir()     { [[ -d "$1" ]] ; }
function has_file()    { [[ -f "$1" ]] ; }
function file_same()   { diff "$1" "$2" > /dev/null ; }

function check_editor
{
    if has_command nvim; then
        diff_command="nvim -i NONE -d"
    elif has_command vim; then
        diff_command="vimdiff"
    else
        error "Error: vim or nvim not found."
        exit 1
    fi
}

function check_all_files
{
    for file in ${file_list[@]}; do
        local file_remote=$(eval echo \$${file}_remote)
        local file_local=$(eval echo \$${file}_local)

        if ! has_file "$file_local"; then
            return 1
        fi

        if ! file_same "$file_remote" "$file_local"; then
            return 1
        fi
    done
    return
}

function run_edit
{
    if check_all_files; then
        success "All files are the same. Nothing to do."
        return
    fi

    for file in ${file_list[@]}; do
        local file_remote=$(eval echo \$${file}_remote)
        local file_local=$(eval echo \$${file}_local)

        if ! has_file $file_local; then
            local file_local_dir=$(dirname "$file_local")
            read -N1 -p "$file not found, create a copy to \`$file_local\` ? [Y/n] " user_input </dev/tty
            if [[ "$user_input" == $'\n' ]]; then user_input=y; else echo; fi
            if [[ "$user_input" =~ [yY] ]]; then
                has_dir $file_local_dir || mkdir -p "$file_local_dir"
                cp "$file_remote" "$file_local"
                success "Copied \`$file_remote\` to \`$file_local\`."
            fi
            continue
        fi

        if file_same "$file_remote" "$file_local"; then
            [[ $verbose == true ]] && success "$file has already been synchronized."
        else
            read -N1 -p "$file unsynchronized. Edit with $diff_command ? [Y/n] " user_input </dev/tty
            if [[ "$user_input" == $'\n' ]]; then user_input=y; else echo; fi
            if [[ "$user_input" =~ [yY] ]]; then
                $diff_command "$file_remote" "$file_local"
                if file_same "$file_remote" "$file_local"; then
                    success "$file is now synchronized."
                else
                    info "$file is still unsynchronized."
                    info "-- Use \`$diff_command \"$file_remote\" \"$file_local\"\` later,"
                    info "-- or try to rerun this script."
                fi
            fi
        fi
    done

    if check_all_files; then
        success "All files are same now."
    fi
}

# main
cmd_parser "$@"
detect_system
declare_dirs
check_editor
run_edit
