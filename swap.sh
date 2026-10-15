#!/bin/bash
# KAnggara Linux Swap Setup & Tuner
# url: https://github.com/KAnggara75/dotfile
#
# Recommended Swap Allocation (General & Cloud Workloads):
#  | RAM Size | Recommended Swap |
#  | :------- | :--------------- |
#  | <= 2GB   | 1GB              |
#  | 3-7GB    | 2GB              |
#  | 8-15GB   | 3GB              |
#  | 16-23GB  | 4GB              |
#  | 24-31GB  | 5GB              |
#  | 32-63GB  | 6GB              |
#  | 64-127GB | 8GB              |
#  | >= 128GB | 11GB             |

set -eo pipefail

SWAP_PATH="/swapfile"
SWAPFILE_SIZE=""
SWAPPINESS="10"
VFS_CACHE_PRESSURE="50"
DRY_RUN=0
SHOW_STATUS_ONLY=0

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Linux Swap Setup, Sizing, and Kernel Parameter Tuner.

Options:
  -s, --size <size>      Custom swap size (e.g. 2G, 4G, 512M). Defaults to auto-calculated RAM ratio.
  -p, --path <path>      Custom swapfile path (defaults to /swapfile).
  --swappiness <val>     vm.swappiness value (defaults to 10).
  --cache-pressure <val> vm.vfs_cache_pressure value (defaults to 50).
  --status               Show current swap and memory allocation status then exit.
  -n, --dry-run          Simulate actions without modifying files or system configuration.
  -h, --help             Show this help message.

Examples:
  $(basename "$0")                      Auto-calculate and configure optimal swap
  $(basename "$0") -n                   Simulate auto-calculation and swap commands
  $(basename "$0") --status             Check active swap devices and kernel params
  $(basename "$0") --size 4G            Force swap allocation to 4GB
EOF
}

abort() {
  echo >&2 "[ERROR] $*"
  exit 1
}

log() {
  printf "==> %s\n" "$*"
}

run_cmd() {
  if [ "${DRY_RUN}" -eq 1 ]; then
    printf "[DRY-RUN] %s\n" "$*"
  else
    "$@"
  fi
}

# Ensure script runs on Linux or gracefully simulates in dry-run
check_os() {
  if [ "$(uname -s)" != "Linux" ]; then
    if [ "${DRY_RUN}" -eq 1 ]; then
      log "Notice: Host platform is $(uname -s). Simulating Linux environment..."
      return 0
    fi
    abort "This swap setup script only supports Linux systems."
  fi
}

show_status() {
  check_os
  log "Current Memory & Swap Status:"
  if command -v free >/dev/null 2>&1; then
    free -h
  fi

  printf "\n"
  log "Active Swap Devices:"
  if command -v swapon >/dev/null 2>&1; then
    swapon --show || true
  elif [ -f /proc/swaps ]; then
    cat /proc/swaps
  fi

  printf "\n"
  log "Kernel VM Tuning:"
  if command -v sysctl >/dev/null 2>&1; then
    sysctl vm.swappiness vm.vfs_cache_pressure 2>/dev/null || true
  fi
}

# Determine optimal swap size based on total RAM
calculate_swap_size() {
  if [ -n "${SWAPFILE_SIZE}" ]; then
    log "Using explicitly specified swap size: ${SWAPFILE_SIZE}"
    return 0
  fi

  local ram_gb=2
  if [ -f /proc/meminfo ]; then
    ram_gb=$(awk '$1~/MemTotal:/ {print int($2/1024/1024)}' /proc/meminfo)
  fi

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

  log "Detected RAM: ${ram_gb} GB -> Selected Swap Size: ${SWAPFILE_SIZE}"
}

# Check disk space availability on target swap path partition
check_disk_space() {
  local target_dir
  target_dir="$(dirname "${SWAP_PATH}")"

  if [ ! -d "${target_dir}" ]; then
    if [ "${DRY_RUN}" -eq 1 ]; then
      log "Target directory '${target_dir}' will be verified on creation."
      return 0
    fi
    abort "Target directory '${target_dir}' does not exist."
  fi

  if command -v df >/dev/null 2>&1; then
    local avail_mb
    avail_mb=$(df -m "${target_dir}" 2>/dev/null | awk 'NR==2 {print $4}')
    local req_mb
    local num_unit
    num_unit=$(echo "${SWAPFILE_SIZE}" | tr '[:lower:]' '[:upper:]')
    if [[ "${num_unit}" =~ G$ ]]; then
      req_mb=$(($(echo "${num_unit}" | tr -dc '0-9') * 1024))
    else
      req_mb=$(echo "${num_unit}" | tr -dc '0-9')
    fi

    if [ -n "${avail_mb}" ] && [ "${avail_mb}" -le "${req_mb}" ]; then
      abort "Insufficient disk space on ${target_dir}: available ${avail_mb}MB, requested ${req_mb}MB."
    fi
  fi
}

# Modern kernel parameter persistence: use /etc/sysctl.d/99-swap.conf when possible
persist_sysctl() {
  local conf_file="/etc/sysctl.d/99-swap.conf"
  local legacy_file="/etc/sysctl.conf"
  local target_file="${conf_file}"

  if [ ! -d "/etc/sysctl.d" ]; then
    target_file="${legacy_file}"
  fi

  log "Persisting sysctl settings to ${target_file}..."

  if [ "${DRY_RUN}" -eq 1 ]; then
    log "[DRY-RUN] Would set vm.swappiness=${SWAPPINESS}"
    log "[DRY-RUN] Would set vm.vfs_cache_pressure=${VFS_CACHE_PRESSURE}"
    log "[DRY-RUN] Would write parameters to ${target_file}"
    return 0
  fi

  sudo sysctl -w "vm.swappiness=${SWAPPINESS}"
  sudo sysctl -w "vm.vfs_cache_pressure=${VFS_CACHE_PRESSURE}"

  if [ "${target_file}" = "${conf_file}" ]; then
    cat <<EOF | sudo tee "${conf_file}" >/dev/null
# Generated by KAnggara dotfile swap setup
vm.swappiness=${SWAPPINESS}
vm.vfs_cache_pressure=${VFS_CACHE_PRESSURE}
EOF
  else
    for param in "vm.swappiness=${SWAPPINESS}" "vm.vfs_cache_pressure=${VFS_CACHE_PRESSURE}"; do
      local key="${param%%=*}"
      local val="${param##*=}"
      if sudo grep -q "^[#[:space:]]*${key}" "${legacy_file}" 2>/dev/null; then
        sudo sed -i "s|^[#[:space:]]*${key}.*|${key}=${val}|" "${legacy_file}"
      else
        echo "${key}=${val}" | sudo tee -a "${legacy_file}" >/dev/null
      fi
    done
  fi
}

create_and_activate_swap() {
  # If swapfile is already active and same size, check if work is required
  if command -v swapon >/dev/null 2>&1; then
    if swapon --show 2>/dev/null | grep -q "${SWAP_PATH}"; then
      log "${SWAP_PATH} is currently active."
      if [ "${DRY_RUN}" -eq 1 ]; then
        log "Would deactivate active swap: sudo swapoff ${SWAP_PATH}"
      else
        log "Turning it off before re-allocating..."
        sudo swapoff "${SWAP_PATH}"
      fi
    fi
  fi

  log "Allocating ${SWAPFILE_SIZE} for ${SWAP_PATH}..."
  if [ "${DRY_RUN}" -eq 1 ]; then
    log "[DRY-RUN] sudo fallocate -l ${SWAPFILE_SIZE} ${SWAP_PATH} || sudo dd if=/dev/zero of=${SWAP_PATH} ..."
    log "[DRY-RUN] sudo chmod 600 ${SWAP_PATH}"
    log "[DRY-RUN] sudo mkswap ${SWAP_PATH}"
    log "[DRY-RUN] sudo swapon ${SWAP_PATH}"
  else
    # Try fallocate first; fallback to dd if filesystem (e.g. Btrfs, XFS) doesn't support fallocate for swap
    if ! sudo fallocate -l "${SWAPFILE_SIZE}" "${SWAP_PATH}" 2>/dev/null; then
      log "fallocate failed or unsupported on filesystem. Falling back to dd..."
      local count_mb
      local num_unit
      num_unit=$(echo "${SWAPFILE_SIZE}" | tr '[:lower:]' '[:upper:]')
      if [[ "${num_unit}" =~ G$ ]]; then
        count_mb=$(($(echo "${num_unit}" | tr -dc '0-9') * 1024))
      else
        count_mb=$(echo "${num_unit}" | tr -dc '0-9')
      fi
      sudo dd if=/dev/zero of="${SWAP_PATH}" bs=1M count="${count_mb}" status=progress
    fi

    log "Setting permissions and initializing swap..."
    sudo chmod 600 "${SWAP_PATH}"
    sudo mkswap "${SWAP_PATH}"
    sudo swapon "${SWAP_PATH}"
  fi

  log "Ensuring ${SWAP_PATH} is configured in /etc/fstab..."
  local fstab_entry="${SWAP_PATH} none swap sw 0 0"

  if [ "${DRY_RUN}" -eq 1 ]; then
    log "[DRY-RUN] Check and add '${fstab_entry}' to /etc/fstab if not present"
  else
    if [ -f /etc/fstab ]; then
      if ! grep -q "${SWAP_PATH}" /etc/fstab; then
        sudo cp /etc/fstab /etc/fstab.bak
        echo "${fstab_entry}" | sudo tee -a /etc/fstab >/dev/null
        log "Added entry to /etc/fstab."
      else
        log "${SWAP_PATH} already present in /etc/fstab."
      fi
    fi
  fi

  persist_sysctl

  if [ "${DRY_RUN}" -eq 1 ]; then
    log "Dry-run simulation completed successfully."
    return 0
  fi

  log "Swap configuration complete:"
  if command -v swapon >/dev/null 2>&1; then
    swapon --show
  fi
  if command -v free >/dev/null 2>&1; then
    free -h
  fi
}

main() {
  while [ $# -gt 0 ]; do
    case "$1" in
    -s | --size)
      [ -n "${2:-}" ] || abort "Missing value for --size"
      SWAPFILE_SIZE="$2"
      shift 2
      ;;
    -p | --path)
      [ -n "${2:-}" ] || abort "Missing value for --path"
      SWAP_PATH="$2"
      shift 2
      ;;
    --swappiness)
      [ -n "${2:-}" ] || abort "Missing value for --swappiness"
      SWAPPINESS="$2"
      shift 2
      ;;
    --cache-pressure)
      [ -n "${2:-}" ] || abort "Missing value for --cache-pressure"
      VFS_CACHE_PRESSURE="$2"
      shift 2
      ;;
    --status)
      SHOW_STATUS_ONLY=1
      shift
      ;;
    -n | --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      abort "Unknown option: $1 (run with -h/--help for usage)"
      ;;
    esac
  done

  if [ "${SHOW_STATUS_ONLY}" -eq 1 ]; then
    show_status
    exit 0
  fi

  check_os
  calculate_swap_size
  check_disk_space
  create_and_activate_swap
}

main "$@" || abort "Swap configuration failed!"
