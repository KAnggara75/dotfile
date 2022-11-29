set -u

abort() {
  printf "%s\n" "$@"
  exit 1
}

download() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1"
  else
    wget -qO- "$1"
  fi
}

get_url() {
  url="$(curl -s https://api.github.com/repos/tonsky/FiraCode/releases/latest |
    grep "browser_download_url.*zip" |
    cut -d : -f 2,3 |
    tr -d \")"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL $url
  else
    wget -qO- $url
  fi
}

main() {
  export LC_CTYPE="en_US.UTF-8"
  if (fc-list) | grep -q "FiraCode"; then
    echo "FiraCode already installed."
  else
    echo "Installing FiraCode."
    get_url | tar -xz -C ~/Library/Fonts --strip-components=1 || return 1
    rm ~/Library/Fonts/FiraCode-*.woff
    rm ~/Library/Fonts/FiraCode-*.woff2
    rm ~/Library/Fonts/FiraCode-VF.ttf
    rm ~/Library/Fonts/FiraCode-Retina.ttf
  fi
}

main
