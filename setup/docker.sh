#!/bin/bash
# KAnggara Docker Setup
# url: https://github.com/KAnggara75/dotfile

DRY_RUN=0

usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS]

KAnggara Docker Setup for Debian/Ubuntu Linux.

Options:
  -n, --dry-run  Simulate actions without executing commands or mutating the system
  -h, --help     Show this help message
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
	linux) platform="linux" ;;
	darwin) platform="macos" ;;
	windows) platform="win" ;;
	esac

	if [ "${platform}" != "linux" ]; then
		return 1
	fi

	printf '%s' "${platform}"
}

add_docker_source() {
	log "Configuring Docker APT repository keyrings..."
	run_cmd sudo apt update
	run_cmd sudo apt install -y ca-certificates curl
	run_cmd sudo install -m 0755 -d /etc/apt/keyrings
	run_cmd sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	run_cmd sudo chmod a+r /etc/apt/keyrings/docker.asc
}

add_docker_repo() {
	log "Adding Docker upstream repository..."
	local codename
	if [ -f /etc/os-release ]; then
		codename="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
	fi
	codename="${codename:-jammy}"

	local arch
	if command -v dpkg >/dev/null 2>&1; then
		arch="$(dpkg --print-architecture)"
	else
		arch="amd64"
	fi

	local repo_entry="deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${codename} stable"

	if [ "${DRY_RUN}" -eq 1 ]; then
		printf "[DRY-RUN] echo \"%s\" | sudo tee /etc/apt/sources.list.d/docker.list\n" "${repo_entry}"
	else
		echo "${repo_entry}" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	fi

	run_cmd sudo apt update
	run_cmd sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

startup_docker() {
	log "Enabling and configuring Docker service permissions..."
	if [ "${DRY_RUN}" -eq 1 ]; then
		run_cmd sudo groupadd -f docker
		run_cmd sudo usermod -aG docker "${USER}"
		run_cmd sudo systemctl enable docker.service
		run_cmd sudo systemctl enable containerd.service
		return 0
	fi

	if ! getent group docker >/dev/null 2>&1; then
		sudo groupadd docker
	fi
	sudo usermod -aG docker "${USER}"
	if [ -d "/home/${USER}/.docker" ]; then
		sudo chown "${USER}:${USER}" "/home/${USER}/.docker" -R
		sudo chmod g+rwx "/home/${USER}/.docker" -R
	fi
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service
}

main() {
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
		*)
			abort "Unknown option: $1 (run with -h/--help for usage)"
			;;
		esac
	done

	local platform
	if ! platform="$(detect_platform)"; then
		if [ "${DRY_RUN}" -eq 1 ]; then
			log "Notice: Host platform is $(uname -s). Simulating Linux (Debian/Ubuntu) deployment..."
		else
			abort "Sorry! Currently only provides for Linux (Debian/Ubuntu) systems."
		fi
	fi

	if command -v docker >/dev/null 2>&1; then
		log "Docker is already installed ($(docker --version 2>/dev/null || echo 'installed'))."
		if [ "${DRY_RUN}" -eq 1 ]; then
			log "Dry-run check: No changes needed."
		fi
		return 0
	fi

	if [ "${DRY_RUN}" -eq 1 ]; then
		log "Running in DRY-RUN mode. No changes will be executed."
	fi

	add_docker_source
	add_docker_repo
	startup_docker

	log "Docker setup completed successfully."
}

main "$@" || abort "Install Error!"
