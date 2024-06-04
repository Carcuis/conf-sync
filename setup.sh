#!/bin/bash

# oh-my-zsh
if [[ ! -e "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh-My-Zsh has already installed."
fi

# zsh-autosuggestions
if [[ ! -e "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions has already installed."
fi

# zsh-syntax-highlighting
if [[ ! -e "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting has already installed."
fi

# zsh-completions
if [[ ! -e "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]]; then
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
else
    echo "zsh-completions has already installed."
fi

# powerlevel10k
if [[ ! -e "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "powerlevel10k has already installed."
fi

# autoupdate-zsh-plugin
if [[ ! -e "$HOME/.oh-my-zsh/custom/plugins/autoupdate" ]]; then
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
else
    echo "autoupdate-zsh-plugin has already installed."
fi

# vim-plug
if [[ ! -e "$HOME/.vim/autoload/plug.vim" ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "Vim-Plug for Vim has already installed."
fi
if command -v nvim > /dev/null; then
    if [[ ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
        curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        echo "Vim-Plug for NeoVim has already installed."
    fi
fi

# vifm-colors
if [[ ! -e "$HOME/.config/vifm/colors/ph.vifm" ]]; then
    vifm
    mv ~/.config/vifm/colors ~/.config/vifm/colors.bak
    git clone https://github.com/vifm/vifm-colors ~/.config/vifm/colors
else
    echo "Vifm colorshemes has already installed."
fi

# vifm-favicons
if [[ ! -e "$HOME/.config/vifm/plugged/favicons.vifm" ]]; then
    wget https://raw.githubusercontent.com/cirala/vifm_devicons/master/favicons.vifm -P ~/.config/vifm/plugged/
else
    echo "Vifm favicons has already installed."
fi
