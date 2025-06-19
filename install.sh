#!/bin/bash
# KAnggara dotfile Automatic Installer
# url: https://github.com/KAnggara75/dotfile

# Global Variable
KA_DIR=~/.tmux/themes/ka-tmux
OH_ZSH_DIR=~/.oh-my-zsh/oh-my-zsh.sh
platform=''

abort() {
  echo $platform
  echo "$@"
  exit 1
}

main() {
  local platform
  platform="$(detect_platform)" || abort "Sorry! currently only provides for UNIX System."
  if [ "${platform}" = "macos" ]; then
    brew_check
  fi

  git_check
  lsd_check
  zsh_check
  ohzsh_check
  if [ "${platform}" = "macos" ]; then
    nerd_check
    iterm_check
  fi

  kanggara_config

  if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ]; then
    tmux_check
    tmux source-file ~/.tmux.conf
  fi
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

  if [ "${platform}" = "win" ]; then
    return 1
  fi

  # set platform to variable
  printf '%s' "${platform}"
}

brew_check() {
  if (brew -v) | sort -Vk3 | tail -1 | grep -q brew; then
    echo "Brew already installed."
  else
    clear
    echo "Homebrew is not installed."
    echo "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

git_check() {
  if (git --version) | sort -Vk3 | tail -1 | grep -q git; then
    echo "Git	already installed."
  else
    clear
    echo "Git is not installed."
    echo "Installing Git."
    if [ "${platform}" = "macos" ]; then
      brew install git
    fi
    if [ "${platform}" = "linux" ]; then
      sudo apt install git -y
    fi
  fi
}

lsd_check() {
  if (lsd -V) | sort -Vk3 | tail -1 | grep -q lsd; then
    echo "lsd	already installed."
  else
    clear
    echo "lsd is not installed."
    echo "Installing lsd."
    if [ "${platform}" = "macos" ]; then
      brew install lsd
    fi
    if [ "${platform}" = "linux" ]; then
      sudo apt install lsd -y
    fi
  fi
}

zsh_check() {
  if (zsh --version) | sort -Vk3 | tail -1 | grep -q zsh; then
    echo "ZSH	already installed."
  else
    clear
    echo "Zsh is not installed."
    echo "Installing Zsh."
    if [ "${platform}" = "macos" ]; then
      brew install zsh
    fi
    if [ "${platform}" = "linux" ]; then
      sudo apt-get install -y language-pack-en zsh
    fi
  fi
}

ohzsh_check() {
  if [ -f $OH_ZSH_DIR ]; then
    echo "OMZ	already installed."
  else
    clear
    echo "Installing Oh-my-zsh"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/ohmyzsh.sh)"
  fi
  sleep 30s
}

nerd_check() {
  if (fc-list) | grep -q "FiraCodeNerdFont"; then
    echo "FiraCodeNerdFont already installed."
  else
    clear
    echo "Installing FiraCodeNerdFont"
    rm ~/Library/Fonts/FiraCodeNerdFont-Regular.ttf
    rm ~/Library/Fonts/FiraCodeNerdFontPropo-Regular.ttf
    cp fonts/FiraCodeNerdFont-Regular.ttf ~/Library/Fonts
    cp fonts/FiraCodeNerdFontPropo-Regular.ttf ~/Library/Fonts
    cd ~
  fi
}

kanggara_config() {
  echo "Installing KAnggara config."
  rm -rf ~/dotfile
  git clone --depth=1 https://github.com/KAnggara75/dotfile.git ~/dotfile
  ln -sf $(pwd)/dotfile/.zshrc ~/.zshrc
  ln -sf $(pwd)/dotfile/.vimrc ~/.vimrc
  ln -sf $(pwd)/dotfile/.zprofile ~/.zprofile
  autosuggestions
}

autosuggestions() {
  read -p "Install zsh-autosuggestions? (Y/n) " yn

  case $yn in
  [Yy]*)
    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ;;
  [Nn]*)
    echo "Skip."
    ;;
  *) echo "Install" ;;
  esac

  if [ "${platform}" = "linux" ]; then
    sudo update-locale
  fi
}

tmux_check() {
  if (tmux -V) | sort -Vk3 | tail -1 | grep -q tmux; then
    echo "tmux already installed."
  else
    tmux_install
  fi
  tmux_config
}

tmux_install() {
  clear
  read -p "Do you wish to install tmux? (Y/n) " yn
  case $yn in
  [Yy]*)
    echo "Tmux is not installed."
    echo "Installing Tmux."
    if [ "${platform}" = "macos" ]; then
      brew install tmux
    fi
    if [ "${platform}" = "linux" ]; then
      sudo apt install tmux -y
    fi
    clear
    ;;
  [Nn]*) ;;
  *) echo "Install" ;;
  esac
}

tmux_config() {
  echo "Installing Tmux config."
  rm -rf $KA_DIR
  mkdir -p ~/.tmux/themes
  ln -sf $(pwd)/dotfile/ka-tmux/ ~/.tmux/themes/ka-tmux
  mv ~/.tmux.conf ~/.tmux.conf.old 2>/dev/null
  ln -sf $(pwd)/dotfile/.tmux.conf ~/.tmux.conf
}

iterm_check() {
  if (mdfind "kMDItemCFBundleIdentifier == com.googlecode.iterm2") | grep -q app; then
    echo "iTerm2 is already installed"
  else
    clear
    echo "iTerm2 is not installed"
    echo "Installing iTerm2"
    brew install --cask iterm2
  fi
}

main || abort "Install Error!"
