#!/bin/bash
# KAnggara MySQL, php, composer, valet, PhpMyAdmin Automatic Installer
# url: https://github.com/KAnggara75/dotfile

PMA=https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip

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
  php_install
}

php_install() {
  echo "Installing PHP."
  brew install php
  composer_install
}

composer_install() {
  clear
  if (composer -V) | sort -Vk3 | tail -1 | grep -q Composer; then
    echo "Composer already installed."
  else
    clear
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
    clear
    echo "Composer installed."
  fi
  clear
  valet_check
}

valet_check() {
  if (valet -V) | sort -Vk3 | tail -1 | grep -q Valet; then
    echo "Valet already installed."
  else
    clear
    echo "Instaling Valet."
    composer global require laravel/valet
    valet install
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    echo "Valet installed."
  fi
}

mysql_check() {
  clear
  if (mysql -V) | sort -Vk3 | tail -1 | grep -q mysql; then
    echo "MySQL already installed."
  else
    clear
    echo "Installing MySQL."
    brew install mysql
    brew services start mysql
    echo "MySQL installed."
  fi
}

main() {
  local platform
  platform="$(detect_platform)" || abort "Sorry! currently only provides for MacOS."
  # check brew
  brew_check
  mysql_check
  mkdir -p ~/dev/pma
  download "$PMA" | tar -xz -C ~/dev/pma --strip-components=1 || return 1
  cd ~/dev/pma
  sed "s/\$cfg\[\'Servers\'\]\[\$i\]\[\'AllowNoPassword\'\] = false;/\$cfg\[\'Servers\'\]\[\$i\]\[\'AllowNoPassword\'\] = true;/" config.sample.inc.php >config.inc.php
  valet link
  valet open
}

main || abort "Install Error!"
