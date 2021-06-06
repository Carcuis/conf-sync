#!/bin/bash

zshrc_remote=.zshrc
zshrc_local=~/.zshrc
vimrc_remote=.vimrc
vimrc_local=~/.vimrc

diff $zshrc_remote $zshrc_local > /dev/null
zshrc_sync_status=$?
diff $vimrc_remote $vimrc_local > /dev/null
vimrc_sync_status=$?

check_status=0

if [ $zshrc_sync_status == 0 ] && [ $vimrc_sync_status == 0 ]; then
    echo -e "\033[32mAll files are the same.✔ \nNothing to do."
    check_status=1
else
    if [ $zshrc_sync_status != 0 ]; then
        read -s -n1 -p "Zshrc unsynchronized. Edit in vimdiff? [Y/n] " user_input
        if [ "$user_input" == "y" ] || [ "$user_input" == "" ]; then
            echo ""
            vimdiff $zshrc_remote $zshrc_local
            diff $zshrc_remote $zshrc_local > /dev/null
            zshrc_sync_status=$?
            if [ $zshrc_sync_status == 0 ]; then
                echo -e "\nZshrc is now synced."
            else
                echo -e "\nZshrc is still unsynchronized.\n--Use \" vimdiff $zshrc_remote $zshrc_local \" later\n--or try to rerun this wizard"
            fi
        else
            echo -e "\nZshrc is still unsynchronized. Aborting."
        fi
    else
        echo -e "Zshrc is already synced."
    fi

    if [ $vimrc_sync_status != 0 ]; then
        read -s -n1 -p "Vimrc unsynchronized. Edit in vimdiff? [Y/n] " user_input
        if [ "$user_input" == "y" ] || [ "$user_input" == "" ]; then
            echo ""
            vimdiff $vimrc_remote $vimrc_local
            diff $vimrc_remote $vimrc_local > /dev/null
            vimrc_sync_status=$?
            if [ $vimrc_sync_status == 0 ]; then
                echo -e "\nVimrc is now synced."
            else
                echo -e "\nVimrc still unsynchronized.\n--Use \" vimdiff $vimrc_remote $vimrc_local \" later\n--or try to rerun this wizard"
            fi
        else
            echo -e "\nVimrc still unsynchronized. Aborting."
        fi
    fi
fi

if [ $zshrc_sync_status == 0 ] && [ $vimrc_sync_status == 0 ] && [ $check_status == 0 ] ; then
    echo -e "\033[32mAll files are same now.✔ "
fi
