#!/bin/bash
# KAnggara Git SSH Signature Setup
# url: https://github.com/KAnggara75/dotfile

set -euo pipefail

DRY_RUN=0

usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS] [SSH_KEY_PUB_PATH]

Configure Git commit signing with an SSH public key.

Arguments:
  SSH_KEY_PUB_PATH  Path to the .pub SSH key (optional, prompts if omitted)

Options:
  -n, --dry-run     Simulate actions without modifying git config
  -h, --help        Show this help message
EOF
}

abort() {
	printf "%s\n" "$@" >&2
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

detect_platform() {
	local platform
	platform="$(uname -s | tr '[:upper:]' '[:lower:]')"
	case "${platform}" in
	linux) echo "linux" ;;
	darwin) echo "macos" ;;
	*) echo "${platform}" ;;
	esac
}

git_check() {
	if command -v git >/dev/null 2>&1; then
		log "Git is already installed ($(git --version))."
		return 0
	fi

	local platform
	platform="$(detect_platform)"
	log "Git is not installed. Installing..."

	if [ "${platform}" = "macos" ]; then
		run_cmd brew install git
	elif [ "${platform}" = "linux" ]; then
		run_cmd sudo apt update
		run_cmd sudo apt install -y git
	else
		abort "Unsupported platform for automatic Git installation: ${platform}"
	fi
}

git_ssh() {
	local selected_key="$1"

	# If no key was passed as argument, look for keys in ~/.ssh
	if [ -z "${selected_key}" ]; then
		local keys=()
		while IFS= read -r k; do
			[ -n "${k}" ] && keys+=("${k}")
		done < <(compgen -G "${HOME}/.ssh/*.pub" || true)

		local total="${#keys[@]}"
		if [ "${total}" -eq 0 ]; then
			abort "No SSH public key (*.pub) found in ${HOME}/.ssh"
		fi

		if [ "${DRY_RUN}" -eq 1 ]; then
			log "Available SSH keys found (${total}):"
			local idx=1
			for k in "${keys[@]}"; do
				printf "  [%d] %s\n" "${idx}" "${k}"
				idx=$((idx + 1))
			done
			selected_key="${keys[0]}"
			log "Dry-run mode: Defaulting selection to first key -> ${selected_key}"
		else
			printf "\nAvailable SSH public keys:\n"
			local idx=1
			for k in "${keys[@]}"; do
				printf "  [%d] %s\n" "${idx}" "${k}"
				idx=$((idx + 1))
			done

			printf "\nSelect SSH File ID (1 to %d): " "${total}"
			read -r num
			num=$(printf '%s\n' "${num}" | tr -dc '[:digit:]')

			if [ -z "${num}" ] || [ "${num}" -le 0 ] || [ "${num}" -gt "${total}" ]; then
				abort "Invalid selection."
			fi
			selected_key="${keys[$((num - 1))]}"
		fi
	fi

	if [ ! -f "${selected_key}" ]; then
		abort "SSH key file does not exist: ${selected_key}"
	fi

	local current_key
	current_key="$(git config --global user.signingkey 2>/dev/null || true)"
	local current_format
	current_format="$(git config --global gpg.format 2>/dev/null || true)"

	if [ "${current_key}" = "${selected_key}" ] && [ "${current_format}" = "ssh" ]; then
		log "Git SSH commit signing is already configured with: ${selected_key}"
		if [ "${DRY_RUN}" -eq 1 ]; then
			log "Dry-run check: No changes needed."
		fi
		return 0
	fi

	log "Configuring Git SSH signing with key: ${selected_key}"
	run_cmd git config --global gpg.format ssh
	run_cmd git config --global user.signingkey "${selected_key}"
	log "Git commit signing configured successfully."
}

main() {
	local ssh_arg=""
	while [ $# -gt 0 ]; do
		case "$1" in
		-n | --dry-run)
			DRY_RUN=1
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		-*)
			abort "Unknown option: $1 (run with -h/--help for usage)"
			;;
		*)
			ssh_arg="$1"
			shift
			;;
		esac
	done

	git_check
	git_ssh "${ssh_arg}"
}

main "$@" || abort "Git setup failed!"
