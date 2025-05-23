# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"
plugins=(git zsh-autosuggestions shrink-path mvn)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source $ZSH/oh-my-zsh.sh

export SBIN_PATH="/usr/local/sbin"
export RUBY_PATH="/usr/local/opt/ruby/bin"
export SVN_PATH="/Users/k/dev/svn/bin"
export NODE_PATH="/usr/local/opt/node@20/bin"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun/bin"
export MY_BIN="$HOME/dev/bin"
# User PATH
export ANDROID_HOME="$HOME/dev/android"
export COMPOSER_HOME="$HOME/.composer/vendor/bin"
export COMPOSER_BIN="$COMPOSER_HOME/vendor/bin"
# Personal dev PATH
export DART_PUB="$HOME/.pub-cache/bin"
export MAVEN_HOME="$HOME/dev/mvn/bin"
export FLUTTER_HOME="$HOME/dev/flutter/bin"
export MONGO_HOME="$HOME/dev/mongo/bin"
export GOPATH="$HOME/go"

# Node Compiler Cofig
export LDFLAGS="-L/$NVM_DIR/versions/node/v22.10.0/lib"
export CPPFLAGS="-I/$NVM_DIR/versions/node/v22.10.0/include"

# For tkinter
# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# KAnggara auto Setup
alias gitsetup='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/gitsetup.sh)"'
alias upv='/bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/KAnggara75/e7f3d7f7c114c1348fec3b2c22f7041e/raw/c9cface5d79fd565c6aa8d147146aa57ff78454c/GitVersion.sh)"'

# lsd alias
alias ls='lsd --group-directories-first'
alias la='ls -lah'
alias ll='ls --git -l'
alias lt='ls -a --tree -I .git -I node_modules'

# ADB alias
alias adbwifi='adb tcpip 5555'

# Git Custom alisa
alias add="git add $1"
alias diff="git diff $1"
alias gcq="git checkout qa"
alias gcmm="git commit -m "$1""
alias gcr="git checkout release"
alias gcms="git commit -S -m "$1""
alias gcma="git commit --amend -S -m "$1""
alias gv="gitversion | jq -r '.FullSemVer'"
alias gcld="git clone --depth=1 $1"
alias gpt="git push --follow-tags"
alias gtag='git tag $(gitversion | jq -r ".FullSemVer") && git push origin $(gitversion | jq -r ".FullSemVer")'
alias ghpage="git add . && git status && git commit -m 'Some descriptive commit message' && git push origin master && git checkout gh-pages && git rebase master && git push origin gh-pages && git checkout master"

# Flutter alias
alias frn="flutter run"
alias fcl="flutter clean"
alias fpa="flutter pub add $1"
alias fpg="flutter pub get"
alias fcr="flutter create $1"
alias fcrun="fcl && fpg && frn"

# node js
# alias npm="pnpm $1"
# alias npx="pnpm dlx"
alias pnpx="pnpm exec"
alias psu="pnpm self-update"
alias pmg="pnpm prisma generate"

#mySQL Alias
alias stopsql="brew services stop mysql"
alias startsql="brew services start mysql"

# Python Virtual Env
alias pip="pip3"
# alias python="python3"
# alias act="source .env/bin/activate"
# alias venv="python3 -m venv .env && source .env/bin/activate"

# ZSH Alias
alias reload="source ~/.zshrc && clear"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias tmuxconfig="code ~/.tmux.conf"

# TMUX ALIAS
alias ide='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50'

# Custom Alias
alias c="clear"
alias st="stree ."
alias q="exit"
alias nv="nvim $1"
alias cod="code ."
alias new="touch $1"
alias rmnm="rm -rf node_modules"
alias iphone="open -a simulator"

# Laravel alias
alias artisan="php artisan $1"
alias migrate="php artisan migrate"
alias val="valet link && valet open"
alias mfs="php artisan migrate:fresh --seed"

# Web Framework alias
alias ci4="composer create-project codeigniter4/appstarter --no-dev $1"

# Java Spring Maven Alias
alias sbsit="mvn-color spring-boot:run -Dspring-boot.run.profiles=sit"
alias sbstg="mvn-color spring-boot:run -Dspring-boot.run.profiles=stg"
alias sbprd="mvn-color spring-boot:run -Dspring-boot.run.profiles=prd"
alias sbdev="mvn-color spring-boot:run -Dspring-boot.run.profiles=dev"

# =================================================================================================
# Change Directory
alias kcc="cd $HOME/work/KAnggara/scc"
alias wp="cd $HOME/work"
alias xl="cd $HOME/Axiata"
alias xll="cd $HOME/AxiataGo"
alias yt="cd $HOME/YouTube"
alias da="cd /Volumes/DATA/"
alias dot="cd $HOME/dotfile"
alias wo="cd /Volumes/DATA/Work"
alias ply="cd $HOME/work/playground"
alias xldb="cd $HOME/Axiata/xlDB"
alias ka="cd /Volumes/DATA/Work/KAnggara"
alias 75="cd /Volumes/DATA/Work/KAnggara75"
alias hk="cd ~/work/KAnggara75/HK"
alias pwa="cd ~/work/PakaiWA"
alias ids="cd ~/work/IDScript"
alias idea='open -na "IntelliJ IDEA.app" --args nosplash "$@"'
alias goland='open -na "GoLand.app" --args nosplash "$@"'
alias ws='open -na "WebStorm.app" --args nosplash "$@"'

# my Project Folder
# alias eday="cd $HOME/Pictures/Photo\ Booth\ Library/Pictures"
alias eday="cd $HOME/work/KAnggara75/eday"
alias efts="cd /Volumes/DATA/efts/atm"
alias wa="cd ~/work/wa"

# ALIAS
if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" = "darwin" ]; then

	alias kaad="/usr/bin/ssh-add --apple-use-keychain ~/.ssh/KAnggara"
	alias sadd="/usr/bin/ssh-add --apple-use-keychain ~/.ssh/KAnggara75"

	# DNS cache Clear
	alias dnsclear="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
	alias chdns="networksetup -getdnsservers Wi-Fi"
	alias rmdns="networksetup -setdnsservers Wi-Fi 9.9.9.9 1.1.1.1 8.8.8.8 8.8.4.4 && chdns"
	alias addns="networksetup -setdnsservers Wi-Fi 10.26.171.174 10.26.171.175 8.8.8.8 && chdns"

	# JDK Version
	alias jdk="export JAVA_HOME='$HOME/dev/openjdk/Contents/Home'"
	alias jdk17="export JAVA_HOME='$HOME/dev/openjdk17/Contents/Home'"
	alias jdk21="export JAVA_HOME='$HOME/dev/openjdk21/Contents/Home'"
	alias jdk23="export JAVA_HOME='$HOME/dev/openjdk23/Contents/Home'"

elif [ "$(uname -s | tr '[:upper:]' '[:lower:]')" = "linux" ]; then
	eval "$(ssh-agent -s)" 2>/dev/null

	alias k="kubectl $@"
	alias kga="kubectl get all"
	alias kgp="kubectl get pod $@"
	alias kaad="/usr/bin/ssh-add ~/.ssh/KAnggara"
	alias sadd="/usr/bin/ssh-add ~/.ssh/KAnggara75"
	alias nnginx="sudo certbot --nginx -d $1"

fi

# PATH
if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" = "darwin" ]; then
	# General Path both mac and linux
	export PNPM_HOME="$HOME/Library/pnpm"
	export JAVA_HOME="$HOME/dev/openjdk/Contents/Home"
	export GRALVM_HOME="$HOME/dev/openjdk/Contents/Home"
	export SOLACE_JMS="$HOME/dev/solace-jms/bin"
	export LIBPQ="/opt/homebrew/opt/libpq/bin"
	export MYSQL_CLIENT="/opt/homebrew/opt/mysql-client@8.4/bin"
	export PATH=$PNPM_HOME:$IDEA_HOME:$SOLACE_JMS:$PATH

	# Provide mac only path here
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

	# bun completions
	[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

elif [ "$(uname -s | tr '[:upper:]' '[:lower:]')" = "linux" ]; then
	export KUBECONFIG=~/.kube/config
	export LIBPQ="/usr/local/opt/libpq/bin"
	export MYSQL_CLIENT="/usr/local/opt/mysql-client/bin"
	# Specific linux only Path
	[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
	[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

fi

# Update PATH
export PATH=$MY_BIN:$GOPATH/bin:$BUN_INSTALL:$MONGO_HOME:$LIBPQ:$MYSQL_CLIENT:$DART_PUB:$SBIN_PATH:$RUBY_PATH:$SVN_PATH:$NODE_PATH:$MAVEN_HOME:$FLUTTER_HOME:$COMPOSER_HOME:$COMPOSER_BIN:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$NVM_DIR:$PATH

prompt_context() {}
prompt_dir() {
	if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ]; then
		prompt_segment red white $(shrink_path -f)
	else
		prompt_segment blue white $(shrink_path -f)
	fi
}

if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ]; then
	if [ $TERM_PROGRAM != tmux ]; then
		if [ $TERM_PROGRAM != "WarpTerminal" ]; then
			# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
			if (tmux ls 2>/dev/null) | tail -1 | grep -q "windows"; then
				tmux a -t $(tmux ls | tail -1 | cut -d : -f1)
			else
				tmux new -s KA
			fi
		fi
	fi
fi
