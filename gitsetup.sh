#!/bin/bash
# KAnggara git signature setup
# url: https://github.com/KAnggara75/dotfile

abort() {
  printf "%s\n" "$@"
  exit 1
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

git_ssh() {
  clear
  n=0
  for file in $HOME/.ssh/*.pub; do
    n=$((n + 1))
    printf "\n[%s] %s" "$n" "$file"
    eval "file${n}=\$file"
  done

  if [ "$n" -eq 0 ]; then
    echo >&2 No SSH File found.
    exit
  fi

  printf '\n\nSelect SSH File ID (1 to %s): ' "$n"
  read -r num
  num=$(printf '%s\n' "$num" | tr -dc '[:digit:]')

  if [ "$num" -le 0 ] || [ "$num" -gt "$n" ]; then
    echo >&2 Wrong selection.
    exit 1
  else
    eval "SSHFILE=\$file${num}"
    echo Selected image is "$SSHFILE"
    git config --global gpg.format ssh
    git config --global user.signingkey $SSHFILE
  fi
}

main() {
  git_check
  git_ssh
}

main || abort "Install Error!"
