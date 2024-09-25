#!/bin/bash
# KAnggara git signature setup
# url: https://github.com/KAnggara75/dotfile
#  | RAM Size | Swap Size |
#  | :------- | :-------- |
#  | 1-2GB    | 1GB       |
#  | 3-6GB    | 2GB       |
#  | 8-12GB   | 3GB       |
#  | 16GB     | 4GB       |
#  | 24GB     | 5GB       |
#  | 32GB     | 6GB       |
#  | 64GB     | 8GB       |
#  | 128GB    | 11GB      |

RAM=$(awk '$1~/MemTotal:/ {print int($2/1000/1000)}' /proc/meminfo)
SWAPFILE=''

get_swap_size() {
  if [[ $RAM -ge 128 ]]; then
    SWAPFILE=11G
  elif [[ $RAM -ge 64 ]] && [[ $RAM -le 128 ]]; then
    SWAPFILE=8G
  elif [[ $RAM -ge 32 ]] && [[ $RAM -le 64 ]]; then
    SWAPFILE=6G
  elif [[ $RAM -ge 24 ]] && [[ $RAM -le 32 ]]; then
    SWAPFILE=5G
  elif [[ $RAM -ge 16 ]] && [[ $RAM -le 24 ]]; then
    SWAPFILE=4G
  elif [[ $RAM -ge 8 ]] && [[ $RAM -le 16 ]]; then
    SWAPFILE=3G
  elif [[ $RAM -ge 3 ]] && [[ $RAM -le 8 ]]; then
    SWAPFILE=2G
  elif [ $RAM -le 2 ]; then
    SWAPFILE=1G
  fi
}

set_swap_file() {
  echo Allocate $SWAPFILE for swap file
  sudo fallocate -l $SWAPFILE /swapfile
  ls -lh /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  sudo swapon --show
  free -h
  sudo cp /etc/fstab /etc/fstab.bak
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  sudo sysctl vm.swappiness=10
  sudo sysctl vm.vfs_cache_pressure=50
  sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sudo -- sh -c "echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf"
}

abort() {
  echo $platform
  echo "$@"
  exit 1
}

main() {
  get_swap_size
  set_swap_file
}

main || abort "Install Error!"
