#!/bin/bash
# KAnggara dot-file Automatic Installer
# url: https://github.com/KAnggara75/dotfile-mac

# Global Variable
HOST=google.com
CONFIG=~/.tmux.conf
KA_DIR=~/.tmux/themes/ka-tmux
CONFIG_LOCAL=~/.tmux.conf.local
OH_ZSH_DIR=~/.oh-my-zsh/oh-my-zsh.sh
# KA_REPO=https://github.com/kanggara75/ka-tmux.git

main(){
  if ping -q -c 1 -W 1 $HOST > /dev/null;  then
    os_check
  else
    echo "You are not connected to the internet"
    exit 0
  fi
  clear
  zsh
}

os_check(){
  if (uname -a) | grep -q Darwin
  then
    echo "Mac OS X"
    brew_check
  elif (uname -a) | grep -q Linux
  then
    echo "Not support Linux yet"
  else
    echo "Unknown OS"
  fi 
  git_check
}

brew_check(){
  if (brew -v) | sort -Vk3 | tail -1 | grep -q brew
  then
    echo -n "Homebrew is already installed => "
    brew -v
  else
    echo "Homebrew is not installed."
    echo "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  iterm_check
}

iterm_check()
{
  if ( mdfind "kMDItemCFBundleIdentifier == com.googlecode.iterm2" ) | grep -q app
  then
    echo "iTerm2 is already installed"
  else
    echo "iTerm2 is not installed"
    echo "Installing iTerm2"
    brew install --cask iterm2
  fi
}

git_check(){
  if (git --version) | sort -Vk3 | tail -1 | grep -q git
  then
    echo -n "Git is already installed. => "
    git --version
  else
    echo "Git is not installed."
    echo "Installing Git."
    brew install git
  fi
  exa_check
}

exa_check(){
  if (exa -v) | sort -Vk3 | tail -1 | grep -q exa
  then
    echo -n "Exa is already installed. => "
    exa -v
  else
    echo "Exa is not installed."
    echo "Installing Exa."
    brew install exa
  fi
  zsh_check
}

zsh_check(){
  if (zsh --version) | sort -Vk3 | tail -1 | grep -q zsh
  then
    echo -n "Zsh is already installed. => "
    zsh --version
  else
    echo "Zsh is not installed."
    echo "Installing Zsh."
    brew install zsh
  fi
  tmux_check
}

tmux_check(){
  if (tmux -V) | sort -Vk3 | tail -1 | grep -q tmux
  then
  echo -n "Tmux is already installed. => "
  tmux -V
  else
  while true; do
    clear
    read -p "Do you wish to install tmux? (Y/n)" yn
    case $yn in
        [Yy]* ) echo "Tmux is not installed."; echo "Installing Tmux."; brew install tmux; break;;
        [Nn]* ) nerd_check; break;;
        * ) echo "Install";;
    esac
  done
  fi
  nerd_check
} 

nerd_check(){
  if (fc-list) | grep -q "Hack Nerd"
  then
    echo "Nerd Fonts is already installed."
  else
    echo "Installing Nerd Fonts"
    brew tap homebrew/cask-fonts
    brew cask install font-hack-nerd-font
  fi
  ohzsh_check
}

ohzsh_check(){
  if [ -f $OH_ZSH_DIR ]
  then
    echo "Oh-my-zsh is already installed."
  else
    echo "Installing Oh-my-zsh"
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  fi
  # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  dir_check
}

dir_check()
{
  echo "Done"
  # ask install tmux?

  # if [ -f ${KA_DIR}/kanggara.tmux ] 
  # then
    # rm -rf $KA_DIR
  # fi
  # ccfg
}

main