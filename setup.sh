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
            error "FAIL($exit_code)"
        fi
    done
}

function install_deps() {
	# oh-my-zsh
	if [[ ! -e "$HOME/.oh-my-zsh" ]]; then
	    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	else
	    info "Oh-My-Zsh has already installed."
	fi

	# zsh-autosuggestions
	if [[ ! -e "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
	    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	else
	    info "zsh-autosuggestions has already installed."
	fi

	# zsh-syntax-highlighting
	if [[ ! -e "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
	    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
	else
	    info "zsh-syntax-highlighting has already installed."
	fi

	# zsh-completions
	if [[ ! -e "$ZSH_CUSTOM/plugins/zsh-completions" ]]; then
	    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
	else
	    info "zsh-completions has already installed."
	fi

	# powerlevel10k
	if [[ ! -e "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
	    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
	else
	    info "powerlevel10k has already installed."
	fi

	# autoupdate-zsh-plugin
	if [[ ! -e "$ZSH_CUSTOM/plugins/autoupdate" ]]; then
	    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM}/plugins/autoupdate
	else
	    info "autoupdate-zsh-plugin has already installed."
	fi

	# vim-plug
	if [[ ! -e "$HOME/.vim/autoload/plug.vim" ]]; then
	    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	else
	    info "Vim-Plug for Vim has already installed."
	fi
	if command -v nvim > /dev/null; then
	    if [[ ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
	        curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	    else
	        info "Vim-Plug for NeoVim has already installed."
	    fi
	fi

	# vifm-colors
	if [[ ! -e "$HOME/.config/vifm/colors/ph.vifm" ]]; then
	    vifm +q
	    mv ~/.config/vifm/colors ~/.config/vifm/colors.bak
	    git clone https://github.com/vifm/vifm-colors ~/.config/vifm/colors
	else
	    info "Vifm colorshemes has already installed."
	fi

	# vifm-favicons
	if [[ ! -e "$HOME/.config/vifm/plugged/favicons.vifm" ]]; then
	    wget https://raw.githubusercontent.com/cirala/vifm_devicons/master/favicons.vifm -P ~/.config/vifm/plugged/
	else
	    info "Vifm favicons has already installed."
	fi

    success "All dependencies have been installed."
}


# main
cmd_parser "$@"
detect_system
install_deps
