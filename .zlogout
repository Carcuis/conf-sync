if [[ $(uname -a) =~ Microsoft || $(uname -a) =~ WSL ]]; then
    pstree $PPID -ap | grep ssh-agent | sed 's/[^0-9]*//g' | xargs kill
fi
