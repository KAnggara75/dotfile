#!/bin/bash
# KAnggara dot-file Automatic Installer
# url: https://github.com/KAnggara75/dotfile

# Global Variable
KA_DIR=~/.tmux/themes/ka-tmux
OH_ZSH_DIR=~/.oh-my-zsh/oh-my-zsh.sh

set -u
abort() {
  printf "%s\n" "$@"
  exit 1
}

main() {
  local platform
  platform="$(detect_platform)" || abort "Sorry! currently only provides for MacOS."
  brew_check
  git_check
  exa_check
  zsh_check
  ohzsh_check
  tmux_check
  # nerd_check
  iterm_check
  tmux source-file ~/.tmux.conf
  exec zsh -l
}

detect_platform() {
  local platform
  platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "${platform}" in
  linux) platform="linux" ;;
  darwin) platform="macos" ;;
  windows) platform="win" ;;
  esac

  if [ "${platform}" = "win" ] || [ "${platform}" = "linux" ]; then
    return 1
  fi

  printf '%s' "${platform}"
}

brew_check() {
  if (brew -v) | sort -Vk3 | tail -1 | grep -q brew; then
    clear
  else
    clear
    echo "Homebrew is not installed."
    echo "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

git_check() {
  if (git --version) | sort -Vk3 | tail -1 | grep -q git; then
    clear
  else
    clear
    echo "Git is not installed."
    echo "Installing Git."
    brew install git
  fi
}

exa_check() {
  if (exa -v) | sort -Vk3 | tail -1 | grep -q exa; then
    clear
  else
    clear
    echo "Exa is not installed."
    echo "Installing Exa."
    brew install exa
  fi
}

zsh_check() {
  if (zsh --version) | sort -Vk3 | tail -1 | grep -q zsh; then
    clear
  else
    clear
    echo "Zsh is not installed."
    echo "Installing Zsh."
    brew install zsh
  fi
}

nerd_check() {
  if (fc-list) | grep -q "Inconsolata"; then
    echo "Installing Nerd Fonts"
  else
    clear
    echo "Installing Nerd Fonts"
    cd ~/Library/Fonts && curl -fLo "Inconsolata Regular Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete.otf
    cd ~
  fi
}

ohzsh_check() {
  clear
  if [ -f $OH_ZSH_DIR ]; then
    echo "Oh-my-zsh is already installed."
  else
    echo "Installing Oh-my-zsh"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/ohmyzsh.sh)"
  fi
}

tmux_check() {
  if (tmux -V) | sort -Vk3 | tail -1 | grep -q tmux; then
    clear
  else
    clear
    while true; do
      clear
      read -p "Do you wish to install tmux? (Y/n)" yn
      case $yn in
      [Yy]*)
        echo "Tmux is not installed."
        echo "Installing Tmux."
        brew install tmux
        break
        ;;
      [Nn]*)
        break
        ;;
      *) echo "Install" ;;
      esac
    done
  fi
  tmux_config
}

tmux_config() {
  while true; do
    clear
    read -p "Use KAnggara config? (Y/n) " yn
    case $yn in
    [Yy]*)
      echo "Installinng config."
      rm -rf $KA_DIR
      rm -rf dotfile
      git clone --depth=1 git@github.com:KAnggara75/dotfile.git
      mkdir -p ~/.tmux/themes
      ln -sf $(pwd)/dotfile/ka-tmux/ ~/.tmux/themes/ka-tmux
      mv ~/.tmux.conf ~/.tmux.conf.old
      ln -sf $(pwd)/dotfile/.tmux.conf ~/.tmux.conf
      ln -sf $(pwd)/dotfile/.zshrc ~/.zshrc
      while true; do
        clear
        read -p "Install zsh-autosuggestions? (Y/n) " yn
        case $yn in
        [Yy]*)
          git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
          break
          ;;
        [Nn]*)
          echo "Skip."
          break
          ;;
        *) echo "Install" ;;
        esac
      done
      break
      ;;
    [Nn]*)
      echo "Skip."
      break
      ;;
    *) echo "Install" ;;
    esac
  done
}

iterm_check() {
  clear
  if (mdfind "kMDItemCFBundleIdentifier == com.googlecode.iterm2") | grep -q app; then
    echo "iTerm2 is already installed"
  else
    echo "iTerm2 is not installed"
    echo "Installing iTerm2"
    brew install --cask iterm2
  fi
}
main || abort "Install Error!"
