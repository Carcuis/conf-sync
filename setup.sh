#!/usr/bin/env bash

DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
source $DIR/scripts/util.sh

verbose=false
no_error=true

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

function cmd_parser() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            h|-h|--help) usage; exit 0 ;;
            t|-t|--test) test_web_connection; exit 0 ;;
            v|-v|--verbose) verbose=true ;;
            *) error "Error: Invalid option '$1'."; usage; exit 1 ;;
        esac
        shift
    done
}

function usage() {
    bold "Usage:"
    mesg "  setup.sh [options]"
    mesg
    bold "Options:"
    mesg "  -h, --help    Display help"
    mesg "  -t, --test    Test web connection, recommended before installation"
    mesg "  -v, --verbose Show detailed information"
}

function test_web_connection() {
    local web_list=(
        "https://www.baidu.com"
        "https://www.google.com"
        "https://github.com"
    )

    for i in ${web_list[@]}
    do
        echo -n "[TEST] $i ... "
        local status_code
        status_code="$(curl -I --max-time 5 $i 2>/dev/null | grep "HTTP" | sed -n '$p' | cut -d ' ' -f 2; exit ${PIPESTATUS[0]})"
        local exit_code=$?
        if [[ $exit_code == 0 && $status_code == 200 ]]; then
            success "OK"
        elif [[ $exit_code == 28 ]]; then
            warning "TIMEOUT"
        else
            error "FAIL($([[ $exit_code != 0 ]] && echo $exit_code || echo $status_code))"
        fi
    done
}

function installing_mesg() { mesg "${BLUE}Installing ${BOLD}$1${BLUE} ..." ; }
function already_installed_mesg() { info "$1 has already installed." ; }

function check_command() {
    if ! has_command $1; then
        warning "Warning: \`$1\` is not installed."
        return 1
    fi
}

function check_deps() {
    local deps=(curl git)
    local missing_deps=false
    for cmd in ${deps[@]}; do
        if ! check_command $cmd; then
            missing_deps=true
        fi
    done
    if [[ $missing_deps == true ]]; then
        warning "Please install the required commands first."
        exit 1
    fi
}

function download() {
    local url=$1
    local dest=$2
    if [[ -z $dest ]]; then
        dest=$(basename $url)
    fi
    if has_file $dest; then
        warning "Warning: $dest already exists, move it to $dest.bak."
        mv $dest{,.bak}
    fi
    curl -fLo $dest --create-dirs $url
    return $?
}

function not_installed_in_dir() {
    if has_dir "$1"; then
        already_installed_mesg "$2"
        return 1
    else
        installing_mesg "$2"
        return 0
    fi
}

function not_installed_file() {
    if has_file "$1"; then
        already_installed_mesg "$2"
        return 1
    else
        installing_mesg "$2"
        return 0
    fi
}

function successfully_installed() {
    if [[ $1 == 0 ]]; then
        success "$2 has been installed."
        return 0
    else
        no_error=false
        error "Error: Failed to install $2."
        return 1
    fi
}

function install_ohmyzsh() {
    if ! has_command zsh; then
        warning "Warning: Zsh is not installed, skip installing Oh-My-Zsh."
        no_error=false
        return 1
    fi

    if not_installed_file "$HOME/.oh-my-zsh/oh-my-zsh.sh" "Oh-My-Zsh"; then
        if has_dir "$HOME/.oh-my-zsh"; then
            mv $HOME/.oh-my-zsh{,.bak}
        fi

        local exit_code=0
        download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
        exit_code=$?

        if [[ $exit_code == 0 ]] && has_file "install.sh"; then
            RUNZSH=no sh install.sh && rm install.sh
            exit_code=$?
        fi
        successfully_installed $exit_code "Oh-My-Zsh"
    fi

    if has_file "$HOME/.oh-my-zsh/oh-my-zsh.sh"; then
        install_ohmyzsh_plugins
    fi
}

function install_ohmyzsh_plugins() {
    if ! has_dir "$ZSH_CUSTOM"; then
        error "Error: Oh-My-Zsh custom directory not found, please check the installation of Oh-My-Zsh."
        no_error=false
        return 1
    fi

    # zsh-users plugins
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
        if not_installed_in_dir "$ZSH_CUSTOM/plugins/$plugin" "$plugin"; then
            git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM}/plugins/$plugin
            successfully_installed $? "$plugin"
        fi
    done

	# powerlevel10k
    if not_installed_in_dir "$ZSH_CUSTOM/themes/powerlevel10k" "powerlevel10k"; then
	    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
        successfully_installed $? "powerlevel10k"
    fi

	# autoupdate-zsh-plugin
    if not_installed_in_dir "$ZSH_CUSTOM/plugins/autoupdate" "autoupdate-oh-my-zsh-plugin"; then
	    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM}/plugins/autoupdate
        successfully_installed $? "autoupdate-oh-my-zsh-plugin"
	fi

    # conda-zsh-completion
    if not_installed_in_dir "$ZSH_CUSTOM/plugins/conda-zsh-completion" "conda-zsh-completion"; then
        git clone https://github.com/conda-incubator/conda-zsh-completion ${ZSH_CUSTOM}/plugins/conda-zsh-completion
        successfully_installed $? "conda-zsh-completion"
    fi
}

function install_vim_plug() {
    if not_installed_file "$HOME/.vim/autoload/plug.vim" "Vim-Plug"; then
        download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "$HOME/.vim/autoload/plug.vim"
        successfully_installed $? "Vim-Plug"
    fi
    if not_installed_file "$HOME/.local/share/nvim/site/autoload/plug.vim" "Vim-Plug for Neovim"; then
        download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
           "$HOME/.local/share/nvim/site/autoload/plug.vim"
        successfully_installed $? "Vim-Plug for Neovim"
    fi
}

function install_vifm_custom() {
    if ! has_command vifm; then
        warning "Warning: Vifm is not installed, skip installing Vifm custom."
        no_error=false
        return 1
    fi

    local vifm_config_home="$HOME/.config/vifm"
    if ! has_dir $vifm_config_home; then
        info "Generating original vifm configuration..."
	    vifm +q
    fi

	# vifm-colors
    if not_installed_file "$vifm_config_home/colors/solarized-dark.vifm" "Vifm colorshemes"; then
	    mv $vifm_config_home/colors{,.bak}
	    git clone https://github.com/vifm/vifm-colors $vifm_config_home/colors
        successfully_installed $? "Vifm colorshemes"
	fi

	# vifm-favicons
    if not_installed_file "$vifm_config_home/plugged/favicons.vifm" "Vifm favicons"; then
        download https://raw.githubusercontent.com/cirala/vifm_devicons/master/favicons.vifm "$vifm_config_home/plugged/favicons.vifm"
        successfully_installed $? "Vifm favicons"
	fi
}

function install_yazi_package() {
    if ! has_command yazi; then
        warning "Warning: Yazi is not installed, skip installing Yazi package."
        no_error=false
        return 1
    fi

    # yazi theme
    if not_installed_file "$HOME/.config/yazi/flavors/catppuccin-mocha.yazi/flavor.toml" "Yazi theme"; then
        ya pack -a yazi-rs/flavors:catppuccin-mocha
        successfully_installed $? "Yazi flavor catppuccin-mocha"
    fi

    # yazi plugins
    if not_installed_file "$HOME/.config/yazi/plugins/smart-enter.yazi/main.lua" "Yazi plugin smart-enter"; then
        ya pack -a yazi-rs/plugins:smart-enter
        successfully_installed $? "Yazi plugin smart-enter"
    fi
    if not_installed_file "$HOME/.config/yazi/plugins/mediainfo.yazi/main.lua" "Yazi plugin mediainfo"; then
        ya pack -a boydaihungst/mediainfo
        successfully_installed $? "Yazi plugin mediainfo"
    fi
}

function install_tmux_plugins() {
    if ! has_command tmux; then
        warning "Warning: Tmux is not installed, skip installing Tmux plugins."
        no_error=false
        return 1
    fi

    local tpm_dir="$HOME/.config/tmux/plugins/tpm"
    if not_installed_file "$tpm_dir/tpm" "Tmux Plugin Manager"; then
        git clone https://github.com/tmux-plugins/tpm $tpm_dir
        successfully_installed $? "Tmux Plugin Manager"

        if has_file "$tpm_dir/scripts/install_plugins.sh"; then
            local tmux_conf_remote="$DIR/.config/tmux/tmux.conf"
            local tmux_conf_local="$HOME/.config/tmux/tmux.conf"
            if ! has_file $tmux_conf_local; then
                info "$tmux_conf_local not found."
                cp $tmux_conf_remote $tmux_conf_local
                successfully_installed $? "Tmux configuration"
            fi
            $tpm_dir/scripts/install_plugins.sh
            successfully_installed $? "Tmux plugins"
        else
            warning "Warning: TPM install_plugins.sh not found."
            no_error=false
        fi
    fi
}

function create_symlink() {
    local src=$1
    local dest=$2
    if has_file $dest; then
        if [[ $(realpath $dest) == $(realpath $src) ]]; then
            info "$dest has already linked."
            return
        else
            warning "Warning: $dest exists, but not linked to $src."
            no_error=false
            return 1
        fi
    else
        ensure_dir $(dirname $dest)
        ln -s $src $dest
        success "Linked $dest to $src."
    fi
}

function link_files() {
    local vimrc=$HOME/.vimrc

    if ! has_file $vimrc; then
        info "$vimrc not found."
        cp $DIR/.vimrc $vimrc
        success "Copied $DIR/.vimrc to $vimrc."
    fi

    create_symlink $vimrc $HOME/.config/nvim/init.vim
    create_symlink $DIR/scripts/check_all.sh $HOME/.local/bin/csc
    create_symlink $DIR/scripts/update.sh $HOME/.local/bin/csup
}

function create_xauth_file() {
    if ! has_command xauth; then
        warning "Warning: xauth is not installed, skip creating xauth file."
        no_error=false
        return 1
    fi

    if ! has_command mcookie; then
        warning "Warning: mcookie command not found, skip creating xauth file."
        warning "    -- If you are in macOS, you can install it via \`brew install util-linux\`."
        no_error=false
        return 1
    fi

    local xauth_file="$HOME/.Xauthority"
    if not_installed_file $xauth_file "Xauthority file"; then
        xauth add :0 . $(mcookie) > /dev/null 2>&1
        successfully_installed $? "Xauthority file"
    fi
}

function install_all() {
    install_ohmyzsh
    install_vim_plug
    install_vifm_custom
    install_yazi_package
    install_tmux_plugins
    link_files
    create_xauth_file

    if [[ $no_error == true ]]; then
        success "All dependencies have been installed."
    fi
}

function main() {
    cmd_parser "$@"
    check_deps
    install_all
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
