# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
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
    colored-man-pages
    git
    z
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    $CMD_NOT_FOUND
)

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ================================
# ==== the bellow is cui_pref ====
# ================================

# zsh-completions
autoload -U compinit && compinit

# if [[ ! $TMUX && ! $VIFM ]]; then
if [[ ! $VIFM ]]; then
    fortune | cowsay | lolcat
fi

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


# ================================
# ============ alias =============
# ================================

if command -v exa > /dev/null; then
    alias ls='exa --icons'
    alias la='exa -a --icons'
    alias ll='exa -aabghHl --icons'
else
    alias ll='ls -alF'
    alias la='ls -AF'
    alias l='ls -CF'
fi
alias wtrsy='curl wttr.in/Songyuan\?lang=zh'
alias wtrgz='curl wttr.in/Guangzhou\?lang=zh'
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

set_proxy() {
    export http_proxy=$1
    export https_proxy=$1
    export all_proxy=$1
}

unset_proxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
}

if [[ $SYSTEM == "WSL1" || $SYSTEM == "WSL2" ]]; then
    alias sshon='sudo service ssh start'
    alias sshoff='sudo service ssh stop'
    # alias cman='man -M /usr/local/share/man/zh_CN'
    alias clp='clip.exe'
    alias adb='adb.exe'
    alias fastboot='fastboot.exe'
    alias o='explorer.exe'
    alias o.='explorer.exe .'
    alias no.='nautilus .'
    alias upx=unset_proxy
    alias bpi='ssh -i ~/.ssh/BPi pi@192.168.137.75'
    alias oneplus='ssh -i ~/.ssh/oneplus -p 8022 u0_a164@192.168.137.10'

    function wtw() {
        sed -e "s/\(.:\)/\/mnt\/\L\0/g" -e 's/\\/\//g' -e 's/://' <<< $1
    }

    if [[ $SYSTEM == "WSL2" ]]; then
        alias px="set_proxy http://$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " "):10809"
    else
        alias px='set_proxy http://127.0.0.1:10809'
        alias x='export DISPLAY=:0.0'
    fi
elif [[ $SYSTEM == "Android" ]]; then
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

if [[ $SYSTEM == "WSL1" || $SYSTEM == "WSL2" ]]; then
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

    # autostart ssh-agent
    if [ -z "$SSH_AUTH_SOCK" ] ; then
        eval `ssh-agent -s` > /dev/null
        ssh-add ~/.ssh/github > /dev/null 2>&1
    fi
elif [[ $SYSTEM == "Android" ]]; then
    ## sshd start-up
    # if [ `ps -ef |grep -w sshd|grep -v grep|wc -l` -le 0 ];then
    #     sshd
    # fi
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
