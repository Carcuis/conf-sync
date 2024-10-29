#!/usr/bin/env bash

verbose=false
no_error=true

BOLD="$(printf '\033[1m')"; TAIL="$(printf '\033[0m')"
RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"; YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"; BLUE="$(printf '\033[34m')"; WHITE="$(printf '\033[37m')"

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

function mesg()     { echo -e "${WHITE}$1${TAIL}" ; }
function info()     { if [[ $verbose == true ]]; then mesg "${CYAN}$1"; fi ; }
function bold()     { mesg "${BOLD}$1" ; }
function success()  { bold "${GREEN}$1 ✔" ; }
function warning()  { bold "${YELLOW}$1" ; }
function error()    { bold "${RED}$1" 1>&2 ; }

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

function detect_system() {
    local _uname_a=$(uname -a)
    if [[ $_uname_a =~ Microsoft ]]; then SYSTEM="WSL1"
    elif [[ $_uname_a =~ WSL2 ]];    then SYSTEM="WSL2"
    elif [[ -n $CODESPACE_NAME ]];   then SYSTEM="Codespace"
    elif [[ $OSTYPE =~ ^darwin ]];   then SYSTEM="Darwin"
    elif [[ $OSTYPE =~ android ]];   then SYSTEM="Android"
    elif [[ $OSTYPE =~ ^linux ]];    then SYSTEM="Linux"
    else error "Error: Unsupported system."; exit 1
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

function install_all() {
    install_ohmyzsh
    install_vim_plug
    install_vifm_custom

    if [[ $no_error == true ]]; then
        success "All dependencies have been installed."
    fi
}


# main
cmd_parser "$@"
detect_system
check_deps
install_all
