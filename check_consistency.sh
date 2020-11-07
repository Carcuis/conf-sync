#!/bin/bash

zshrc_remote=~/github/conf-sync/.zshrc
zshrc_local=~/.zshrc
vimrc_remote=~/github/conf-sync/.vimrc
vimrc_local=~/.vimrc
# diff $file1 $file2 > /dev/null
diff $zshrc_remote $zshrc_local > /dev/null
zshrc_sync_status=$?
diff $vimrc_remote $vimrc_local > /dev/null
vimrc_sync_status=$?
if [[ ! $zshrc_sync_status && ! $vimrc_sync_status ]]; then
	echo -e "\033[32mAll files are the same.✔ \nNothing to do."
else
#	echo "Both file are different.✘ "
	if [ ! $zshrc_sync_status ]; then
		read -s -n1 -p "Zshrc unsynchronized. Edit in vimdiff? [y/n] " user_input
		if [ $user_input == "y" ]; then
			vim $zshrc_remote -c "vert diffsplit $zshrc_local"
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
	if [ $vimrc_sync_status ]; then
		read -s -n1 -p "Vimrc unsynchronized. Edit in vimdiff? [y/n] " user_input
		if [ $user_input == "y" ]; then
			vim $vimrc_remote -c "vert diffsplit $vimrc_local"
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
if [[ ! $zshrc_sync_status && ! $vimrc_sync_status ]]; then
	echo -e "\033[32mAll files are same now.✔ "
fi
