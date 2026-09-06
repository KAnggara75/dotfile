#!/bin/bash
# KAnggara Linux Swap Setup
# url: https://github.com/KAnggara75/dotfile
#
# Recommended Swap Allocation:
#  | RAM Size | Swap Size |
#  | :------- | :-------- |
#  | <= 2GB   | 1GB       |
#  | 3-7GB    | 2GB       |
#  | 8-15GB   | 3GB       |
#  | 16-23GB  | 4GB       |
#  | 24-31GB  | 5GB       |
#  | 32-63GB  | 6GB       |
#  | 64-127GB | 8GB       |
#  | >= 128GB | 11GB      |

set -eo pipefail

SWAP_PATH="/swapfile"
SWAPFILE_SIZE=""

abort() {
  echo >&2 "[ERROR] $*"
  exit 1
}

# Ensure script runs on Linux
check_os() {
  if [ "$(uname -s)" != "Linux" ]; then
    abort "This swap setup script only supports Linux systems."
  fi
  if [ ! -f /proc/meminfo ]; then
    abort "/proc/meminfo not found. Cannot determine RAM size."
  fi
}

# Determine optimal swap size based on total RAM
calculate_swap_size() {
  local ram_gb
  ram_gb=$(awk '$1~/MemTotal:/ {print int($2/1024/1024)}' /proc/meminfo)

  if [ "$ram_gb" -ge 128 ]; then
    SWAPFILE_SIZE="11G"
  elif [ "$ram_gb" -ge 64 ]; then
    SWAPFILE_SIZE="8G"
  elif [ "$ram_gb" -ge 32 ]; then
    SWAPFILE_SIZE="6G"
  elif [ "$ram_gb" -ge 24 ]; then
    SWAPFILE_SIZE="5G"
  elif [ "$ram_gb" -ge 16 ]; then
    SWAPFILE_SIZE="4G"
  elif [ "$ram_gb" -ge 8 ]; then
    SWAPFILE_SIZE="3G"
  elif [ "$ram_gb" -ge 3 ]; then
    SWAPFILE_SIZE="2G"
  else
    SWAPFILE_SIZE="1G"
  fi

  echo "==> Detected RAM: ${ram_gb} GB -> Selected Swap Size: ${SWAPFILE_SIZE}"
}

# Persist sysctl setting without duplicating lines
set_sysctl_param() {
  local key="$1"
  local val="$2"
  local conf_file="/etc/sysctl.conf"

  sudo sysctl -w "${key}=${val}"

  if sudo grep -q "^[#[:space:]]*${key}" "${conf_file}" 2>/dev/null; then
    sudo sed -i "s|^[#[:space:]]*${key}.*|${key}=${val}|" "${conf_file}"
  else
    echo "${key}=${val}" | sudo tee -a "${conf_file}" >/dev/null
  fi
}

create_and_activate_swap() {
  # If swapfile is already active, turn it off first
  if swapon --show | grep -q "${SWAP_PATH}"; then
    echo "==> ${SWAP_PATH} is currently active. Turning it off..."
    sudo swapoff "${SWAP_PATH}"
  fi

  echo "==> Allocating ${SWAPFILE_SIZE} for ${SWAP_PATH}..."
  # Try fallocate first; fallback to dd if filesystem (e.g. Btrfs, XFS) doesn't support fallocate for swap
  if ! sudo fallocate -l "${SWAPFILE_SIZE}" "${SWAP_PATH}" 2>/dev/null; then
    echo "==> fallocate failed. Falling back to dd..."
    local count_mb
    count_mb=$(echo "${SWAPFILE_SIZE}" | tr -dc '0-9')
    count_mb=$((count_mb * 1024))
    sudo dd if=/dev/zero of="${SWAP_PATH}" bs=1M count="${count_mb}" status=progress
  fi

  echo "==> Setting permissions and initializing swap..."
  sudo chmod 600 "${SWAP_PATH}"
  sudo mkswap "${SWAP_PATH}"
  sudo swapon "${SWAP_PATH}"

  echo "==> Ensuring ${SWAP_PATH} in /etc/fstab..."
  if [ -f /etc/fstab ] && ! grep -q "${SWAP_PATH}" /etc/fstab; then
    sudo cp /etc/fstab /etc/fstab.bak
    echo "${SWAP_PATH} none swap sw 0 0" | sudo tee -a /etc/fstab >/dev/null
  fi

  echo "==> Tuning swappiness and cache pressure..."
  if [ -f /etc/sysctl.conf ]; then
    sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
  fi
  set_sysctl_param "vm.swappiness" "10"
  set_sysctl_param "vm.vfs_cache_pressure" "50"

  echo "==> Swap setup complete:"
  swapon --show
  free -h
}

main() {
  check_os
  calculate_swap_size
  create_and_activate_swap
}

main || abort "Swap configuration failed!"
