if [[ $SYSTEM == "WSL2" ]]; then
    pstree $PPID -ap | grep ssh-agent | sed 's/[^0-9]*//g' | xargs kill
fi
