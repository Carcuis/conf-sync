#!/bin/bash

zshrc_remote=.zshrc
zshrc_local=~/.zshrc
vimrc_remote=.vimrc
vimrc_local=~/.vimrc

diff $zshrc_remote $zshrc_local > /dev/null
zshrc_sync_status=$?
diff $vimrc_remote $vimrc_local > /dev/null
vimrc_sync_status=$?

has_nvim=0
has_vim=0
if command -v nvim > /dev/null; then
    has_nvim=1
    diff_tool="nvim -d"
elif command -v vim > /dev/null; then
    has_vim=1
    diff_tool="vimdiff"
else
    echo -e "\033[31mNo vim or neovim found on your device.\nAborting...\033[0m"
    exit 1
fi

function DiffFunc
{
    if [ $has_nvim == 1 ]; then
        nvim -d $1 $2
    elif [ $has_vim == 1 ]; then
        vimdiff $1 $2
    fi
}

check_status=0

if [ $zshrc_sync_status == 0 ] && [ $vimrc_sync_status == 0 ]; then
    echo -e "\033[32mAll files are the same.✔ \nNothing to do."
    check_status=1
else
    if [ $zshrc_sync_status != 0 ]; then
        read -s -n1 -p "Zshrc unsynchronized. Edit with $diff_tool ? [Y/n] " user_input
        if [ "$user_input" == "y" ] || [ "$user_input" == "" ]; then
            echo ""
            DiffFunc $zshrc_remote $zshrc_local
            diff $zshrc_remote $zshrc_local > /dev/null
            zshrc_sync_status=$?
            if [ $zshrc_sync_status == 0 ]; then
                echo -e "\nZshrc is now synced."
            else
                echo -e "\nZshrc is still unsynchronized.\n--Use \" $diff_tool $zshrc_remote $zshrc_local \" later\n--or try to rerun this wizard"
            fi
        else
            echo -e "\nZshrc is still unsynchronized. Aborting."
        fi
    else
        echo -e "Zshrc is already synced."
    fi

    if [ $vimrc_sync_status != 0 ]; then
        read -s -n1 -p "Vimrc unsynchronized. Edit with $diff_tool ? [Y/n] " user_input
        if [ "$user_input" == "y" ] || [ "$user_input" == "" ]; then
            echo ""
            DiffFunc $vimrc_remote $vimrc_local
            diff $vimrc_remote $vimrc_local > /dev/null
            vimrc_sync_status=$?
            if [ $vimrc_sync_status == 0 ]; then
                echo -e "\nVimrc is now synced."
            else
                echo -e "\nVimrc still unsynchronized.\n--Use \" $diff_tool $vimrc_remote $vimrc_local \" later\n--or try to rerun this wizard"
            fi
        else
            echo -e "\nVimrc still unsynchronized. Aborting."
        fi
    fi
fi

if [ $zshrc_sync_status == 0 ] && [ $vimrc_sync_status == 0 ] && [ $check_status == 0 ] ; then
    echo -e "\033[32mAll files are same now.✔ "
fi
