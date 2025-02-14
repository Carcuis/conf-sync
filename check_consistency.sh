#!/usr/bin/env bash

DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
source $DIR/scripts/util.sh

verbose=${verbose:-false}
force_sync=${force_sync:-false}
diff_command=${diff_command:-""}

declare -ag file_list=(
    zshrc
    vimrc
)
declare -ag extra_file_list=(
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
    tmux_conf
    tmux_nerd_font_window_name_yml
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
    tmux_conf_remote=$DIR/.config/tmux/tmux.conf
    tmux_conf_local=$HOME/.config/tmux/tmux.conf
    tmux_nerd_font_window_name_yml_remote=$DIR/.config/tmux/tmux-nerd-font-window-name.yml
    tmux_nerd_font_window_name_yml_local=$HOME/.config/tmux/tmux-nerd-font-window-name.yml

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
            sshd_config_remote=$DIR/android/sshd_config
            sshd_config_local=/data/data/com.termux/files/usr/etc/ssh/sshd_config
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
            addon_file_list+=( shortcut_sshd sshd_config )
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
   mesg "  -f, --force-sync Force sync files"
   mesg "  -h, --help       Display help"
   mesg "  -v, --verbose    Show detailed information"
}

function cmd_parser() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            a|-a|--all) file_list+=( ${extra_file_list[@]} ) ;;
            h|-h|--help) usage; exit 0 ;;
            v|-v|--verbose) verbose=true ;;
            f|-f|--force-sync) make_sync_force ;;
            *) error "Error: Invalid option '$1'"; usage; exit 1 ;;
        esac
        shift
    done
}

function make_sync_force() {
    force_sync=true
    diff_command="backup_and_copy"
}

function backup_and_copy() {
    local src=$1
    local dest=$2
    local dest_dir=$(dirname "$dest")
    local backup_dir=$DIR/backup

    ensure_dir $dest_dir
    ensure_dir $backup_dir

    if has_file $dest; then
        local backup_file=$backup_dir/$(basename $dest).$(date +%y%m%d_%H%M%S)
        if ! move_file $dest $backup_file; then
            return 1
        fi
        info "Backuped \`$dest\` to \`$backup_file\`."
    fi

    if ! copy_file $src $dest; then
        return 1
    fi
}

function owned_by_root() {
    local root
    local file="$1"
    [[ $SYSTEM == "Darwin" ]] && root=$(stat -f %Su "$file" 2>&1) || root=$(stat -c %U "$file")
    [[ $root == "root" ]]
}

function check_editor() {
    if has_command nvim; then
        diff_command="nvim -i NONE -d"
    elif has_command vim; then
        diff_command="vimdiff"
    else
        error "Error: vim or nvim not found."
        exit 1
    fi
}

function check_all_files() {
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
}

function confirm() {
    if [[ $force_sync == true ]]; then
        return 0
    fi

    local user_input
    read -n1 -p "$1 [Y/n] " user_input </dev/tty
    [[ -z $user_input ]] && user_input=y || echo
    [[ "$user_input" =~ [yY] ]] && return 0 || return 1
}

function transfer_file() {
    local operation=$1
    local src=$2
    local dest=$3
    local src_dir=$(dirname "$src")
    local dest_dir=$(dirname "$dest")

    ensure_dir $dest_dir
    if owned_by_root $src_dir || owned_by_root $dest_dir; then
        if ! sudo $operation "$src" "$dest"; then
            return 1
        fi
    else
        if ! $operation "$src" "$dest"; then
            return 1
        fi
    fi
}

function copy_file() {
    transfer_file cp "$1" "$2"
}

function move_file() {
    transfer_file mv "$1" "$2"
}

function run_edit() {
    if check_all_files; then
        success "All files are the same. Nothing to do."
        return
    fi

    [[ $force_sync == true ]] || check_editor

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
                if [[ $force_sync == false ]] && owned_by_root $file_local; then
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

function main() {
    cmd_parser "$@"
    declare_dirs
    run_edit
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
