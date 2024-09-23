if [[ ! $VIFM ]]; then
    fortune | cowsay -f moose -W $(($(tput cols)-3<80?$(tput cols)-3:80)) | lolcat
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
for user_path in \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.fzf/bin \
    /usr/local/bin
do
    [[ -d $user_path ]] && [[ ! $PATH == *$user_path* ]] && export PATH=$user_path:$PATH
done

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if ! [[ "$OSTYPE" =~ android ]]; then
    CMD_NOT_FOUND="command-not-found"
fi
plugins=(
    autoupdate
    colored-man-pages
    git
    python
    z
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    $CMD_NOT_FOUND
)

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export PYTHON_AUTO_VRUN=true
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

source $ZSH/oh-my-zsh.sh

# zsh-completion @ref: https://github.com/zsh-users/zsh-completions/issues/603#issuecomment-967116106
autoload -U compinit && compinit

eval "$(register-python-argcomplete pipx)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ================================
# ==== the bellow is cui_pref ====
# ================================

# set editor
if command -v nvim > /dev/null; then
    export EDITOR=nvim
elif command -v vim > /dev/null; then
    export EDITOR=vim
elif command -v vi > /dev/null; then
    export EDITOR=vi
fi

# system detection
function detect_system() {
    local _uname_a=$(uname -a)

    if [[ $_uname_a =~ Microsoft ]]; then
        SYSTEM="WSL1"
    elif [[ $_uname_a =~ WSL2 ]]; then
        SYSTEM="WSL2"
    elif [[ "$OSTYPE" =~ ^darwin ]]; then
        SYSTEM="Darwin"
    elif [[ "$OSTYPE" =~ android ]]; then
        SYSTEM="Android"
    elif [[ "$OSTYPE" =~ ^linux ]]; then
        SYSTEM="Linux"
    else
        SYSTEM="Unknown"
    fi
}
detect_system

# proxy env settings
function set_proxy() {
    export http_proxy=$1
    export https_proxy=$1
    export all_proxy=$1
}
function unset_proxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ALL_PROXY
}

# web connection detection
function web_detection() {
    local web_list=(
        "https://www.baidu.com"
        "https://www.google.com"
        "https://github.com"
    )

    for i in $web_list
    do
        echo -n "[TEST] $i ... "
        local status_code=0
        status_code="$(curl -I --max-time 5 $i 2>/dev/null | grep "HTTP" | sed -n '$p' | cut -d ' ' -f 2; exit ${pipestatus[1]})"
        local exit_code=$?
        if [[ $exit_code == 0 && $status_code == 200 ]]; then
            echo -e "\033[1;32mOK\033[0m"
        elif [[ $exit_code == 28 ]]; then
            echo -e "\033[1;33mTIMEOUT\033[0m"
        else
            echo -e "\033[1;31mFAIL($([[ $exit_code != 0 ]] && echo $exit_code || echo $status_code))\033[0m"
        fi
    done
}

# weather forecast
function weather_forecast() {
    curl wttr.in/$1\?lang=zh
}

# ================================
# ============ alias =============
# ================================

if command -v eza > /dev/null; then
    alias ls='eza --hyperlink --icons=auto'
    alias la='eza --hyperlink --icons=auto -a'
    alias lag='eza --hyperlink --icons=auto -a --git-ignore'
    alias ll='eza --hyperlink --icons=auto -aghHlM --git'
    alias llg='eza --hyperlink --icons=auto -aghHlM --git --git-ignore'
    alias llt='eza --hyperlink --icons=auto -aghHlM --git --git-ignore -T -L3'
elif command -v exa > /dev/null; then
    alias ls='exa --icons'
    alias la='exa -a --icons'
    alias ll='exa -aabghHl --icons'
else
    alias ll='ls -alF'
    alias la='ls -AF'
    alias l='ls -CF'
fi
alias zshc="$EDITOR ~/.zshrc"
alias vimc="$EDITOR ~/.vimrc"
alias src='source ~/.zshrc'
alias vifm='vifm .'
alias vif='vifm'
alias gvi='gvim'
alias nvi='nvim'
alias lvi='lvim'
alias al='la'
alias lg='lazygit'
alias pp='ptpython'
alias wd=web_detection
alias wtr=weather_forecast
alias histc="$EDITOR ~/.zsh_history"
alias ktc="$EDITOR ~/.config/kitty/kitty.conf"
alias dac=deactivate

if [[ $SYSTEM =~ "WSL[12]" ]]; then
    function wtw() {
        sed -e "s/\(.:\)/\/mnt\/\L\0/g" -e 's/\\/\//g' -e 's/://' <<< $1
    }

    function wsl_get_proxy_server() {
        local server
        if [[ $SYSTEM == "WSL1" ]]; then
            server="127.0.0.1"
        else
            server=$(ip route show | grep -i default | awk '{print $3}')
        fi
        echo $server
    }

    function wsl_get_proxy_port() {
        local port=$(/mnt/c/Windows/system32/reg.exe query \
            "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" \
            /v ProxyServer | sed -n 3p | awk -F: 'BEGIN{RS="\r\n"}{print $2}')
        echo $port
    }

    function wsl_has_windows_ie_proxy() {
        local has_ie_proxy=$(/mnt/c/Windows/system32/reg.exe query \
            "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" \
            /v ProxyEnable | sed -n 3p | awk 'BEGIN{RS="\r\n"}{print $3}')
        if [[ $has_ie_proxy == 0x1 ]]; then
            return 0
        else
            return 1
        fi
    }

    function detect_and_set_proxy() {
        if wsl_has_windows_ie_proxy; then
            set_proxy http://$(wsl_get_proxy_server):$(wsl_get_proxy_port)
        fi
    }
    detect_and_set_proxy

    alias sshon='sudo service ssh start'
    alias sshoff='sudo service ssh stop'
    # alias cman='man -M /usr/local/share/man/zh_CN'
    alias clp='clip.exe'
    alias adb='adb.exe'
    alias fastboot='fastboot.exe'
    alias o='explorer.exe'
    alias o.='explorer.exe .'
    alias no.='nautilus .'
    alias px="set_proxy http://$(wsl_get_proxy_server):$(wsl_get_proxy_port)"
    alias upx=unset_proxy
    alias nvid='neovide.exe --wsl'

    if [[ $SYSTEM == "WSL1" ]]; then
        alias x='export DISPLAY=:0.0'
    fi
elif [[ $SYSTEM == "Android" ]]; then
    unalias ktc
    alias tchroot='termux-chroot'
    # alias ubuntu='bash ~/ubuntu/start-ubuntu.sh'
    alias chcolor='/data/data/com.termux/files/home/.termux/colors.sh'
    alias chfont='/data/data/com.termux/files/home/.termux/fonts.sh'
    alias termc='vim ~/.termux/termux.properties'
    alias ubuntu2004='~/ubuntu/2004/start-ubuntu20.sh'
elif [[ $SYSTEM == "Linux" ]]; then
    # alias sshon='sudo service ssh start'
    # alias sshoff='sudo service ssh stop'
    # alias fix-pod='pactl load-module module-bluetooth-discover'
    alias o='nautilus'
    alias o.='nautilus .'
    alias px='set_proxy http://127.0.0.1:1089'
    alias upx=unset_proxy
elif [[ $SYSTEM == "Darwin" ]]; then
    # alias cmake-gui='/Applications/CMake.app/Contents/MacOS/CMake .'
    alias sshon='sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist'
    alias sshoff='sudo launchctl unload -w /System/Library/LaunchDaemons/ssh.plist'
    alias fixroot='sudo mount -uw /'
    alias fix='xattr -d com.apple.FinderInfo'
    alias o='open'
    alias o.='open .'
    alias px='set_proxy http://127.0.0.1:1087'
    alias upx=unset_proxy
fi

# ================================
# ============= env ==============
# ================================

# === pkg-config ===
# PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
# export PKG_CONFIG_PATH

if [[ $SYSTEM =~ "WSL[12]" ]]; then
    if [[ $SYSTEM == "WSL1" ]]; then
        # adjust login path
        if [ "$PWD" = "/mnt/c/Users/cui" ]; then
            cd ~
        elif [ "$PWD" = "/mnt/c/Windows/system32" ]; then
            cd ~
        elif [ "$PWD" = "/mnt/c/Windows/System32" ]; then
            cd ~
        fi
        # display env
        export DISPLAY=127.0.0.1:0.0
    fi

    # autostart ssh-agent - deprecated, use Github CLI instead
    # if [ -z "$SSH_AUTH_SOCK" ] ; then
    #     eval `ssh-agent -s` > /dev/null
    #     ssh-add ~/.ssh/github > /dev/null 2>&1
    # fi

    export BROWSER="$HOME/.local/bin/msedge"
    [[ -d "$HOME/.local/bin/" ]] || mkdir -p "$HOME/.local/bin/"
    [[ -f "$BROWSER" ]] || ln -s "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" "$BROWSER"

elif [[ $SYSTEM == "Android" ]]; then
    ## sshd start-up
    # if [ $(pgrep sshd | wc -l) -le 0 ];then
    #     sshd
    # fi
    if [ ! $XDG_RUNTIME_DIR ]; then
        export XDG_RUNTIME_DIR=/data/data/com.termux/files/usr/tmp/runtime/
    fi
elif [[ $SYSTEM == "Linux" ]]; then
    # === ROS ===
    # alias src-ros-env='source /opt/ros/melodic/setup.zsh'
    ## or auto source when shell start up
    # source /opt/ros/melodic/setup.zsh

    # === CLion ===
    # alias clion='~/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/202.7319.72/bin/clion.sh'

    # === OpenVINO ===
    # alias src-openvino-env='source /opt/intel/openvino/bin/setupvars.sh'
    ## or auto source when shell start up
    # source /opt/intel/openvino/bin/setupvars.sh

elif [[ $SYSTEM == "Darwin" ]]; then
    # === Openni2 ===
    # export OPENNI2_INCLUDE=/usr/local/include/ni2
    # export OPENNI2_REDIST=/usr/local/lib/ni2
fi

# === Powerlevel10k ===
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZLE_RPROMPT_INDENT=0
POWERLEVEL9K_TIME_FORMAT=%D{%H:%M}
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(
    node_version          # node.js version
    go_version            # go version (https://golang.org)
    rust_version          # rustc version (https://www.rust-lang.org)
    package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
    proxy                 # system-wide http/https/ftp proxy
    battery               # internal battery
)

# === fzf ===
if command -v fzf > /dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
        --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#2b2b2b
        --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
        --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
        --color=border:#262626,label:#aeaeae,query:#d9d9d9
        --bind=ctrl-b:preview-page-up,ctrl-f:preview-page-down
        --preview="bat --color=always --style=header {}"
        --preview-window="border-rounded" --prompt=" " --marker="◆" --pointer=" "
        --separator="─" --scrollbar="│" --layout="reverse"'
fi
