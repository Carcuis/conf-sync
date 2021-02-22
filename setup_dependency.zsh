#!/bin/zsh
#oh-my-zsh
if [[ ! -e "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh-My-Zsh has already installed."
fi
#zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#powerlevel10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#vifm-colors
if [[ ! -e "$HOME/.config/vifm/colors/ph.vifm" ]]; then
    vifm
    mv ~/.config/vifm/colors/Default.vifm ~/.config/Default.vifm.bak
    rmdir ~/.config/vifm/colors
    git clone https://github.com/vifm/vifm-colors ~/.config/vifm/colors
    mv ~/.config/Default.vifm.bak ~/.config/vifm/colors/
else
    echo "Vifm colorshemes already exist."
fi
