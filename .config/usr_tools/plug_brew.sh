#!/usr/bin/env bash
#brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# ohmyzsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp $HOME/.config/usr_tools/node.zsh-theme $HOME/.oh-my-zsh/themes

# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

