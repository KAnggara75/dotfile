#!/bin/bash
# KAnggara Docker Setup
# url: https://github.com/KAnggara75/dotfile

abort() {
  printf "%s\n" "$@"
  exit 1
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
   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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
  add_docker_source
  add_docker_repo
  startup_docker
}

main || abort "Install Error!"
