#!/bin/bash
# KAnggara dotfile Automatic Installer
# url: https://github.com/KAnggara75/dotfile

set -eo pipefail

# Configuration & Directories
DOTFILE_DIR="${HOME}/dotfile"
KA_TMUX_DIR="${HOME}/.tmux/themes/ka-tmux"
OH_MY_ZSH_DIR="${HOME}/.oh-my-zsh"
OH_ZSH_FILE="${OH_MY_ZSH_DIR}/oh-my-zsh.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM=""

abort() {
  echo >&2 "[ERROR] $*"
  exit 1
}

detect_platform() {
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    linux) echo "linux" ;;
    darwin) echo "macos" ;;
    *) return 1 ;;
  esac
}

brew_check() {
  if command -v brew >/dev/null 2>&1; then
    echo "==> Homebrew already installed."
  else
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
}

git_check() {
  if command -v git >/dev/null 2>&1; then
    echo "==> Git already installed."
  else
    echo "==> Installing Git..."
    if [ "${PLATFORM}" = "macos" ]; then
      brew install git
    elif [ "${PLATFORM}" = "linux" ]; then
      sudo apt-get update && sudo apt-get install -y git
    fi
  fi
}

lsd_check() {
  if command -v lsd >/dev/null 2>&1; then
    echo "==> lsd already installed."
  else
    echo "==> Installing lsd..."
    if [ "${PLATFORM}" = "macos" ]; then
      brew install lsd
    elif [ "${PLATFORM}" = "linux" ]; then
      sudo apt-get update && sudo apt-get install -y lsd
    fi
  fi
}

zsh_check() {
  if command -v zsh >/dev/null 2>&1; then
    echo "==> Zsh already installed."
  else
    echo "==> Installing Zsh..."
    if [ "${PLATFORM}" = "macos" ]; then
      brew install zsh
    elif [ "${PLATFORM}" = "linux" ]; then
      sudo apt-get update && sudo apt-get install -y language-pack-en zsh
    fi
  fi
}

ohzsh_check() {
  if [ -f "${OH_ZSH_FILE}" ]; then
    echo "==> Oh My Zsh already installed."
  else
    echo "==> Installing Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

nerd_check() {
  local font_dir="${HOME}/Library/Fonts"
  mkdir -p "${font_dir}"

  if [ -f "${font_dir}/FiraCodeNerdFont-Regular.ttf" ]; then
    echo "==> FiraCode Nerd Font already installed."
    return 0
  fi

  echo "==> Installing FiraCode Nerd Font..."
  if [ -d "${DOTFILE_DIR}/fonts" ]; then
    cp "${DOTFILE_DIR}/fonts/"*.ttf "${font_dir}/"
  elif [ -d "${SCRIPT_DIR}/fonts" ]; then
    cp "${SCRIPT_DIR}/fonts/"*.ttf "${font_dir}/"
  else
    echo "==> Warning: Font directory not found. Skipping font copy."
  fi
}

kanggara_config() {
  echo "==> Setting up dotfiles symlinks..."

  # If running remotely / fresh install without existing dotfile repo
  if [ ! -d "${DOTFILE_DIR}/.git" ]; then
    if [ -d "${SCRIPT_DIR}/.git" ]; then
      DOTFILE_DIR="${SCRIPT_DIR}"
    else
      echo "==> Cloning dotfile repo to ${DOTFILE_DIR}..."
      git clone --depth=1 https://github.com/KAnggara75/dotfile.git "${DOTFILE_DIR}"
    fi
  fi

  ln -sf "${DOTFILE_DIR}/.zshrc" "${HOME}/.zshrc"
  ln -sf "${DOTFILE_DIR}/.zshenv" "${HOME}/.zshenv"
  ln -sf "${DOTFILE_DIR}/.vimrc" "${HOME}/.vimrc"
  ln -sf "${DOTFILE_DIR}/.zprofile" "${HOME}/.zprofile"

  mkdir -p "${HOME}/.config"
  ln -sf "${DOTFILE_DIR}/nvim" "${HOME}/.config/nvim"

  install_plugins
}

clone_or_update_plugin() {
  local repo_url="$1"
  local target_dir="$2"

  if [ -d "${target_dir}/.git" ]; then
    echo "==> Updating $(basename "${target_dir}")..."
    git -C "${target_dir}" pull --quiet
  else
    echo "==> Cloning $(basename "${target_dir}")..."
    git clone --depth=1 "${repo_url}" "${target_dir}"
  fi
}

install_plugins() {
  read -r -p "Install/update recommended Zsh plugins? (Y/n) " yn
  case "${yn}" in
    [Nn]*)
      echo "==> Skipped plugin installation."
      ;;
    *)
      local custom_plugins="${ZSH_CUSTOM:-${OH_MY_ZSH_DIR}/custom}/plugins"
      mkdir -p "${custom_plugins}"

      clone_or_update_plugin "https://github.com/fdellwing/zsh-bat.git" "${custom_plugins}/zsh-bat"
      clone_or_update_plugin "https://github.com/MichaelAquilina/zsh-you-should-use.git" "${custom_plugins}/you-should-use"
      clone_or_update_plugin "https://github.com/zsh-users/zsh-autosuggestions" "${custom_plugins}/zsh-autosuggestions"
      clone_or_update_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${custom_plugins}/zsh-syntax-highlighting"
      ;;
  esac

  if [ "${PLATFORM}" = "linux" ] && command -v update-locale >/dev/null 2>&1; then
    sudo update-locale
  fi
}

tmux_check() {
  if command -v tmux >/dev/null 2>&1; then
    echo "==> tmux already installed."
  else
    tmux_install
  fi
  tmux_config
}

tmux_install() {
  read -r -p "Do you wish to install tmux? (Y/n) " yn
  case "${yn}" in
    [Nn]*)
      echo "==> Skipped tmux installation."
      ;;
    *)
      echo "==> Installing tmux..."
      if [ "${PLATFORM}" = "macos" ]; then
        brew install tmux
      elif [ "${PLATFORM}" = "linux" ]; then
        sudo apt-get update && sudo apt-get install -y tmux
      fi
      ;;
  esac
}

tmux_config() {
  echo "==> Configuring tmux..."
  mkdir -p "${HOME}/.tmux/themes"
  rm -rf "${KA_TMUX_DIR}"
  ln -sf "${DOTFILE_DIR}/ka-tmux" "${KA_TMUX_DIR}"

  if [ -f "${HOME}/.tmux.conf" ] && [ ! -L "${HOME}/.tmux.conf" ]; then
    mv "${HOME}/.tmux.conf" "${HOME}/.tmux.conf.old"
  fi
  ln -sf "${DOTFILE_DIR}/.tmux.conf" "${HOME}/.tmux.conf"
}

iterm_check() {
  if [ -d "/Applications/iTerm.app" ] || mdfind "kMDItemCFBundleIdentifier == 'com.googlecode.iterm2'" | grep -q app; then
    echo "==> iTerm2 already installed."
  else
    echo "==> Installing iTerm2..."
    brew install --cask iterm2
  fi
}

main() {
  PLATFORM="$(detect_platform)" || abort "Sorry! Currently only macOS and Linux are supported."

  if [ "${PLATFORM}" = "macos" ]; then
    brew_check
  fi

  git_check
  lsd_check
  zsh_check
  ohzsh_check

  if [ "${PLATFORM}" = "macos" ]; then
    nerd_check
    iterm_check
  fi

  kanggara_config

  if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ] && command -v tmux >/dev/null 2>&1; then
    tmux_check
    if [ -f "${HOME}/.tmux.conf" ]; then
      tmux source-file "${HOME}/.tmux.conf" 2>/dev/null || true
    fi
  fi

  echo "==> Installation completed successfully!"
  if [ -t 0 ] && [ -n "${SHELL}" ]; then
    exec zsh -l
  fi
}

main || abort "Install Error!"
