#!/bin/bash
# KAnggara dotfile Automatic Installer
# url: https://github.com/KAnggara75/dotfile

# Global Variable
KA_DIR=~/.tmux/themes/ka-tmux
OH_ZSH_DIR=~/.oh-my-zsh/oh-my-zsh.sh
platform=''

set -u
abort() {
		echo $platform
		echo "$@"
		exit 1
}

main() {
		local platform
		platform="$(detect_platform)" || abort "Sorry! currently only provides for UNIX System."
		if [ "${platform}" = "macos" ]; then
				brew_check
		fi
		git_check
		exa_check
		zsh_check
		ohzsh_check
		tmux_check
		# nerd_check
		if [ "${platform}" = "macos" ]; then
				iterm_check
		fi
		tmux source-file ~/.tmux.conf
		exec zsh -l
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
		
		# set platform to variable
		printf '%s' "${platform}"
}

brew_check() {
		if (brew -v) | sort -Vk3 | tail -1 | grep -q brew; then
				echo "Brew already installed."
		else
				clear
				echo "Homebrew is not installed."
				echo "Installing Homebrew."
				/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi
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

exa_check() {
		if (exa -v) | sort -Vk3 | tail -1 | grep -q exa; then
				echo "exa	already installed."
		else
				clear
				echo "Exa is not installed."
				echo "Installing Exa."
				if [ "${platform}" = "macos" ]; then
						brew install exa
				fi
				if [ "${platform}" = "linux" ]; then
						sudo apt install exa -y
				fi
		fi
}

zsh_check() {
		if (zsh --version) | sort -Vk3 | tail -1 | grep -q zsh; then
				echo "ZSH	already installed."
		else
				clear
				echo "Zsh is not installed."
				echo "Installing Zsh."
				if [ "${platform}" = "macos" ]; then
						brew install zsh
				fi
				if [ "${platform}" = "linux" ]; then
						sudo apt-get install -y language-pack-en zsh
				fi
		fi
}

ohzsh_check() {
		if [ -f $OH_ZSH_DIR ]; then
				echo "OMZ	already installed."
		else
				clear
				echo "Installing Oh-my-zsh"
				/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/ohmyzsh.sh)"
		fi
		sleep 30s
}

nerd_check() {
		if (fc-list) | grep -q "Inconsolata"; then
				echo "Installing Nerd Fonts"
		else
				clear
				echo "Installing Nerd Fonts"
				cd ~/Library/Fonts && curl -fLo "Inconsolata Regular Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete.otf
				cd ~
		fi
}

tmux_check() {
		if (tmux -V) | sort -Vk3 | tail -1 | grep -q tmux; then
				echo "tmux already installed."
		else
				while true; do
						clear
						read -p "Do you wish to install tmux? (Y/n) " yn
						case $yn in
								[Yy]*)
										echo "Tmux is not installed."
										echo "Installing Tmux."
										if [ "${platform}" = "macos" ]; then
												brew install tmux
										fi
										if [ "${platform}" = "linux" ]; then
												sudo apt install tmux -y
										fi
										clear
										break
								;;
								[Nn]*)
										break
								;;
								*) echo "Install" ;;
						esac
				done
		fi
		tmux_config
}

tmux_config() {
		read -p "Use KAnggara config? (Y/n) " yn
		case $yn in
				[Yy]*)
						echo "Installing config."
						rm -rf $KA_DIR
						rm -rf dotfile
						git clone --depth=1 https://github.com/KAnggara75/dotfile.git
						mkdir -p ~/.tmux/themes
						ln -sf $(pwd)/dotfile/ka-tmux/ ~/.tmux/themes/ka-tmux
						mv ~/.tmux.conf ~/.tmux.conf.old 2> /dev/null
						ln -sf $(pwd)/dotfile/.tmux.conf ~/.tmux.conf
						ln -sf $(pwd)/dotfile/.zshrc ~/.zshrc
						while true; do
								read -p "Install zsh-autosuggestions? (Y/n) " yn
								case $yn in
										[Yy]*)
												git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
												break
										;;
										[Nn]*)
												echo "Skip."
												break
										;;
										*) echo "Install" ;;
								esac
						done
						if [ "${platform}" = "linux" ]; then
								sudo update-locale
						fi
						break
				;;
				[Nn]*)
						echo "Skip."
						break
				;;
				*) echo "Install" ;;
				
		esac
		
}

iterm_check() {
		if (mdfind "kMDItemCFBundleIdentifier == com.googlecode.iterm2") | grep -q app; then
				echo "iTerm2 is already installed"
		else
				clear
				echo "iTerm2 is not installed"
				echo "Installing iTerm2"
				brew install --cask iterm2
		fi
}

main || abort "Install Error!"
