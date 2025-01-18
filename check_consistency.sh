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
    global_gitconfig
    shellcheckrc
    kitty_config
    kitty_linux
    vifmrc
    tealdeer_config
    condarc
    yazi_config
    yazi_keymap
    yazi_theme
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
    global_gitconfig_remote=$DIR/dot_files/.gitconfig
    global_gitconfig_local=$HOME/.gitconfig
    shellcheckrc_remote=$DIR/dot_files/.shellcheckrc
    shellcheckrc_local=$HOME/.shellcheckrc
    kitty_config_remote=$DIR/.config/kitty/kitty.conf
    kitty_config_local=$HOME/.config/kitty/kitty.conf
    kitty_linux_remote=$DIR/.config/kitty/kitty_linux.conf
    kitty_linux_local=$HOME/.config/kitty/kitty_linux.conf
    vifmrc_remote=$DIR/.config/vifm/vifmrc
    vifmrc_local=$HOME/.config/vifm/vifmrc
    tealdeer_config_remote=$DIR/.config/tealdeer/config.toml
    tealdeer_config_local=$HOME/.config/tealdeer/config.toml
    condarc_remote=$DIR/dot_files/.condarc
    condarc_local=$HOME/.condarc
    yazi_config_remote=$DIR/.config/yazi/yazi.toml
    yazi_config_local=$HOME/.config/yazi/yazi.toml
    yazi_keymap_remote=$DIR/.config/yazi/keymap.toml
    yazi_keymap_local=$HOME/.config/yazi/keymap.toml
    yazi_theme_remote=$DIR/.config/yazi/theme.toml
    yazi_theme_local=$HOME/.config/yazi/theme.toml

    case $SYSTEM in
        Darwin)
            ptpython_config_local="$HOME/Library/Application Support/ptpython/config.py"
            lazygit_config_local="$HOME/Library/Application Support/lazygit/config.yml"
            kitty_macos_remote=$DIR/.config/kitty/kitty_macos.conf
            kitty_macos_local=$HOME/.config/kitty/kitty_macos.conf
            ;;
        Android)
            shortcut_sshd_remote=$DIR/android/.shortcuts/sshd
            shortcut_sshd_local=$HOME/.shortcuts/sshd
            ;;
        WSL*)
            wsl_conf_remote=$DIR/windows/wsl/wsl.conf
            wsl_conf_local=/etc/wsl.conf
            ;;
        Codespace)
            global_gitconfig_remote=$DIR/misc/codespace/.gitconfig
            ;;
    esac

    local -a exclude_file_list
    local -a addon_file_list

    case $SYSTEM in
        Android)
            exclude_file_list+=( ideavimrc kitty_config kitty_linux condarc );
            addon_file_list+=( shortcut_sshd )
            ;;
        WSL*)
            exclude_file_list+=( ideavimrc )
            addon_file_list+=( wsl_conf )
            ;;
        Darwin)
            exclude_file_list+=( kitty_linux )
            addon_file_list+=( kitty_macos )
            ;;
        Codespace)
            exclude_file_list+=( ideavimrc kitty_config )
            ;;
    esac

    if [[ ${#exclude_file_list[@]} != 0 ]]; then
        for exclude_file in ${exclude_file_list[@]}; do
            file_list=( ${file_list[@]/$exclude_file} )
        done
        info "Skipped ${exclude_file_list[*]} on current system: ${GREEN}$SYSTEM ✔"
    fi

    if [[ ${#addon_file_list[@]} != 0 ]]; then
        for addon_file in ${addon_file_list[@]}; do
            file_list+=( $addon_file )
        done
        info "Added ${addon_file_list[*]} on current system: ${GREEN}$SYSTEM ✔"
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
    elif [[ -n $CODESPACE_NAME ]];   then SYSTEM="Codespace"
    elif [[ $OSTYPE =~ ^darwin ]];   then SYSTEM="Darwin"
    elif [[ $OSTYPE =~ android ]];   then SYSTEM="Android"
    elif [[ $OSTYPE =~ ^linux ]];    then SYSTEM="Linux"
    else SYSTEM="Unknown"
    fi
}
detect_system

function has_command() { command -v "$1" > /dev/null ; }
function has_dir()     { [[ -d "$1" ]] ; }
function has_file()    { [[ -f "$1" ]] ; }
function file_same()   { diff "$1" "$2" > /dev/null ; }
function ensure_dir()  { has_dir "$1" || mkdir -p "$1" ; }

function owned_by_root
{
    local _cmd
    [[ $SYSTEM == "Darwin" ]] && _cmd="stat -f %Su" || _cmd="stat -c %U"
    [[ $($_cmd "$1") == "root" ]]
}

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

function confirm() {
    local user_input
    read -n1 -p "$1 [Y/n] " user_input </dev/tty
    [[ -z $user_input ]] && user_input=y || echo
    [[ "$user_input" =~ [yY] ]] && return 0 || return 1
}

function copy_file() {
    local src=$1
    local dest=$2
    local dest_dir=$(dirname "$dest")

    ensure_dir $dest_dir
    if owned_by_root $dest_dir; then
        if ! sudo cp "$src" "$dest"; then
            return 1
        fi
    else
        if ! cp "$src" "$dest"; then
            return 1
        fi
    fi
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
            if confirm "$file not found, create a copy to \`$file_local\` ?"; then
                if ! copy_file "$file_remote" "$file_local"; then
                    error "Error: Failed to copy \`$file_remote\` to \`$file_local\`."
                    continue
                fi
                success "Copied \`$file_remote\` to \`$file_local\`."
            fi
            continue
        fi

        if file_same "$file_remote" "$file_local"; then
            [[ $verbose == true ]] && success "$file has already been synchronized."
        else
            if confirm "$file unsynchronized. Edit with $diff_command ?"; then
                if owned_by_root $file_local; then
                    diff_command="sudo -E env PATH=$PATH $diff_command"
                fi

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
declare_dirs
check_editor
run_edit
