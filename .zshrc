# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
if [[ "$OSTYPE" =~ ^darwin ]]; then
	export ZSH="/Users/cui/.oh-my-zsh"
elif [[ "$OSTYPE" =~ ^linux ]]; then
	export ZSH="/home/cui/.oh-my-zsh"
fi

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
plugins=(
	colored-man-pages
	git
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
)

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

# ----the bellow is cui_pref----

# if [[ ! $TMUX && ! $VIFM ]]; then
if [[ ! $VIFM ]]; then
	# neofetch
	# fortune|cowsay -f dragon-and-cow|lolcat
	fortune|cowsay|lolcat
fi

# ---------alias----------\
alias ll='ls -alF'
alias la='ls -AF'
alias l='ls -CF'
alias wtrsy='curl wttr.in/Songyuan\?lang=zh'
alias wtrgz='curl wttr.in/Guangzhou\?lang=zh'
alias aliyun='ssh -i ~/.ssh/aliyun -p 2235 cui@47.107.62.60'
alias aliyunzh='LANG="zh_CN.UTF-8" ; ssh -i ~/.ssh/aliyun -p 2235 cui@47.107.62.60 ; LANG="en_US.UTF-8"'
alias oneplus='ssh -i ~/.ssh/oneplus -p 8022 u0_a144@172.28.241.220'
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
alias src='source ~/.zshrc'
alias vifm='vifm .'
alias vif='vifm .'
alias al='la'
# alias termux='ssh -p 8022 192.168.43.1'
# alias xytermux='ssh -p 8022 10.44.68.197'
# alias termux='ssh -p 8022 172.28.247.98'
# alias tubuntu='ssh -p 2235 192.168.43.1'
# alias xytubuntu='ssh -p 2235 10.44.68.197'
# alias aliyun='ssh -p 2235 cui@47.107.62.60'
# alias aliyunroot='ssh -p 2235 root@47.107.62.60'

# alias nethack='nethack@nethack-cn.com -p2222'

if [[ $`uname -a` =~ Microsoft ]]; then
	alias sshon='sudo service ssh start'
	alias sshoff='sudo service ssh stop'
	alias neofetch='neofetch --ascii_distro windows10'
	# alias byobu='LANG="en_US.UTF-8" ; byobu'
	alias x='export DISPLAY=:0.0'
	alias cman='man -M /usr/local/share/man/zh_CN'
	alias clp='clip.exe'
	alias adb='adb.exe'
	alias fastboot='fastboot.exe'
elif [[ "$OSTYPE" =~ ^linux ]]; then
	# alias sshon='sudo service ssh start'
	# alias sshoff='sudo service ssh stop'
	# alias byobu='LANG="en_US.UTF-8" ; byobu'
elif [[ "$OSTYPE" =~ ^darwin ]]; then
	alias cmake-gui='/Applications/CMake.app/Contents/MacOS/CMake .'
	alias sshon='sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist'
	alias sshoff='sudo launchctl unload -w /System/Library/LaunchDaemons/ssh.plist'
	alias fix='xattr -d com.apple.FinderInfo'
	alias o='open'
	alias o.='open .'
fi
# ---------alias---------/

# ----------env----------\

# ----opencv----\
# PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
# export PKG_CONFIG_PATH
# --------------/

if [[ $`uname -a` =~ Microsoft ]]; then
	# adjust login path
	if [ "$PWD" = "/mnt/c/Users/cui" ]; then
		cd ~
	elif [ "$PWD" = "/mnt/c/Windows/system32" ]; then
		cd ~
	elif [ "$PWD" = "/mnt/c/Windows/System32" ]; then
		cd ~
	fi
	# ---------------
elif [[ "$OSTYPE" =~ ^linux ]]; then
	# ------ros------\
	alias src-ros-env='source /opt/ros/melodic/setup.zsh'
	# *or auto source when shell start up
	source /opt/ros/melodic/setup.zsh
	# ---------------/

	# -----clion-----\
	alias clion='~/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/202.7319.72/bin/clion.sh'
	# ---------------/

	# ---openvino----\
	alias src-openvino-env='source /opt/intel/openvino/bin/setupvars.sh'
	# *or auto source when shell start up
	# source /opt/intel/openvino/bin/setupvars.sh
	# ---------------/

elif [[ "$OSTYPE" =~ ^darwin ]]; then
	# ----cmake-gui----\
	alias cmake-gui='/Applications/CMake.app/Contents/MacOS/CMake .'
	# -----------------/

	# ----openni2----\
	# export OPENNI2_INCLUDE=/usr/local/include/ni2
	# export OPENNI2_REDIST=/usr/local/lib/ni2
	# ---------------/
fi
# ----------env----------/

# -----powerlevel10k-----

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# the bellow is cui_pref with p10k
ZLE_RPROMPT_INDENT=0
POWERLEVEL9K_TIME_FORMAT=%D{%H:%M}
