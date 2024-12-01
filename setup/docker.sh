#!/bin/bash
# KAnggara Docker Setup
# url: https://github.com/KAnggara75/dotfile

platform=''

abort() {
	printf "%s\n" "$@"
	exit 1
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

	if [ "${platform}" = "macos" ]; then
		return 1
	fi

	# set platform to variable
	printf '%s' "${platform}"
}

add_docker_source() {
	sudo apt update
	sudo apt install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
}

add_docker_repo() {
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
		sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update
	sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

startup_docker() {
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker
	sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
	sudo chmod g+rwx "$HOME/.docker" -R
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service
}

main() {
	local platform
	platform="$(detect_platform)" || abort "Sorry! currently only provides for Linux System."
	if [ "${platform}" = "linux" ]; then
		add_docker_source
		add_docker_repo
		startup_docker
	fi
}

main || abort "Install Error!"
