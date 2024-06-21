#!/usr/bin/env bash

verbose=0

BOLD="$(printf '\033[1m')" TAIL="$(printf '\033[0m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"; BLUE="$(printf '\033[34m')"; WHITE="$(printf '\033[37m')"

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

function mesg()     { echo -e "${WHITE}$1${TAIL}" ; }
function info()     { if [[ $verbose == 1 ]]; then mesg "${CYAN}$1"; fi ; }
function bold()     { mesg "${BOLD}$1" ; }
function success()  { bold "${GREEN}$1 ✔" ; }
function warning()  { bold "${YELLOW}$1" ; }
function error()    { bold "${RED}$1" 1>&2 ; }

function cmd_parser() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            h|-h|--help) usage; exit 0 ;;
            t|-t|--test) test_web_connection; exit 0 ;;
            v|-v|--verbose) verbose=1 ;;
            *) error "Error: Invalid option '$1'"; usage; exit 1 ;;
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

function detect_system() {
    local _uname_a=$(uname -a)
    if [[ $_uname_a =~ Microsoft ]]; then SYSTEM="WSL1"
    elif [[ $_uname_a =~ WSL2 ]];    then SYSTEM="WSL2"
    elif [[ $OSTYPE =~ ^darwin ]];   then SYSTEM="Darwin"
    elif [[ $OSTYPE =~ android ]];   then SYSTEM="Android"
    elif [[ $OSTYPE =~ ^linux ]];    then SYSTEM="Linux"
    else error "Error: Unsupported system"; exit 1
    fi
    mesg "${CYAN}Current system: ${GREEN}$SYSTEM${TAIL}"
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

function has_command() { command -v "$1" > /dev/null ; }
function has_dir() { [[ -d "$1" ]] ; }
function has_file() { [[ -f "$1" ]] ; }

function install_mesg() { mesg "${BLUE}Installing ${BOLD}$1${BLUE} ..." ; }
function already_installed_mesg() { info "$1 has already installed." ; }

function check_commands() {
    local commands=(curl wget git zsh vim nvim vifm)
    local command_not_found=0
    for cmd in ${commands[@]}; do
        if ! has_command $cmd; then
            error "Error: $cmd is not installed"
            command_not_found=1
        fi
    done
    if [[ $command_not_found == 1 ]]; then
        warning "Please install the required commands first."
        exit 1
    fi
}

function install_ohmyzsh() {
    if has_dir "$HOME/.oh-my-zsh"; then
        already_installed_mesg "Oh-My-Zsh"
    else
        install_mesg "Oh-My-Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

function install_ohmyzsh_plugins() {
    # zsh-users plugins
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
        if has_dir "$ZSH_CUSTOM/plugins/$plugin"; then
            already_installed_mesg "$plugin"
        else
            install_mesg "$plugin"
            git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM}/plugins/$plugin
        fi
    done

	# powerlevel10k
	if has_dir "$ZSH_CUSTOM/themes/powerlevel10k"; then
	    already_installed_mesg "powerlevel10k"
	else
        install_mesg "powerlevel10k"
	    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
	fi

	# autoupdate-zsh-plugin
	if has_dir "$ZSH_CUSTOM/plugins/autoupdate"; then
	    already_installed_mesg "autoupdate-oh-my-zsh-plugin"
	else
        install_mesg "autoupdate-oh-my-zsh-plugin"
	    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM}/plugins/autoupdate
	fi
}

function install_vim_plug() {
    if has_file "$HOME/.vim/autoload/plug.vim"; then
        already_installed_mesg "Vim-Plug"
    else
        install_mesg "Vim-Plug"
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    if has_file "$HOME/.local/share/nvim/site/autoload/plug.vim"; then
        already_installed_mesg "Vim-Plug for Neovim"
    else
        install_mesg "Vim-Plug for Neovim"
        curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

function install_vifm_custom() {
    local vifm_config_home="$HOME/.config/vifm"
    if ! has_dir $vifm_config_home; then
        info "Generating original vifm configuration..."
	    vifm +q
    fi

	# vifm-colors
	if has_file "$vifm_config_home/colors/solarized-dark.vifm"; then
	    already_installed_mesg "Vifm colorshemes"
	else
        install_mesg "Vifm colorshemes"
	    mv $vifm_config_home/colors $vifm_config_home/colors.bak
	    git clone https://github.com/vifm/vifm-colors $vifm_config_home/colors
	fi

	# vifm-favicons
	if has_file "$vifm_config_home/plugged/favicons.vifm"; then
	    already_installed_mesg "Vifm favicons"
	else
        install_mesg "Vifm favicons"
	    wget https://raw.githubusercontent.com/cirala/vifm_devicons/master/favicons.vifm -P $vifm_config_home/plugged/
	fi
}

function install_deps() {
    install_ohmyzsh
    install_ohmyzsh_plugins
    install_vim_plug
    install_vifm_custom

    success "All dependencies have been installed."
}


# main
cmd_parser "$@"
detect_system
check_commands
install_deps
