# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# -------------------------------------
# OH-MY-ZSH & BASIC ENV
# -------------------------------------
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"

ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"
plugins=(git shrink-path mvn)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source "$ZSH/oh-my-zsh.sh"

# -------------------------------------
# BASE PATHS & ENV VARS
# -------------------------------------
export SBIN_PATH="/usr/local/sbin"
export RUBY_PATH="/usr/local/opt/ruby/bin"
export NODE_PATH="/usr/local/opt/node@20/bin"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun/bin"
export MY_BIN="$HOME/dev/bin"
# User PATH
export ANDROID_HOME="$HOME/dev/android"
export COMPOSER_HOME="$HOME/.composer/vendor"
# Personal dev PATH
export DART_PUB="$HOME/.pub-cache/bin"
export MAVEN_HOME="$HOME/dev/mvn/bin"
export FLUTTER_HOME="$HOME/dev/flutter/bin"
export MONGO_HOME="$HOME/dev/mongo/bin"
export GOPATH="$HOME/go"
export AWS_DEFAULT_REGION=ap-southeast-3

# Node Compiler Config
export LDFLAGS="-L$NVM_DIR/versions/node/v22.16.0/lib"
export CPPFLAGS="-I$NVM_DIR/versions/node/v22.16.0/include"

# -------------------------------------
# CUSTOM FUNCTIONAL ALIASES
# -------------------------------------
# Helper for alias with arguments (zsh function style)
add() { git add "$@"; }
diff() { git diff "$@"; }
gcmm() { git commit -m "$*"; }
gcms() { git commit -S -m "$*"; }
gcma() { git commit --amend -S -m "$*"; }
gcld() { git clone --depth=1 "$1"; }
fpa() { flutter pub add "$1"; }
fcr() { flutter create "$1"; }
nv() { nvim "$@"; }
new() { touch "$@"; }
artisan() { php artisan "$@"; }

# Aliases
alias gitsetup='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/gitsetup.sh)"'
alias upv='/bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/KAnggara75/e7f3d7f7c114c1348fec3b2c22f7041e/raw/c9cface5d79fd565c6aa8d147146aa57ff78454c/GitVersion.sh)"'

# lsd alias
alias ls='lsd --group-directories-first'
alias la='ls -lah'
alias ll='ls --git -l'
alias lt='ls -a --tree -I .git -I node_modules'

# Git quick
alias gcq="git checkout qa"
alias gcr="git checkout release"
alias gv='echo v$(gitversion | jq -r ".MajorMinorPatch")'
alias gpt="git push --follow-tags"
alias gtag='git tag v$(gitversion | jq -r ".MajorMinorPatch") && git push origin v$(gitversion | jq -r ".MajorMinorPatch")'
alias ghpage="git add . && git status && git commit -m 'Some descriptive commit message' && git push origin master && git checkout gh-pages && git rebase master && git push origin gh-pages && git checkout master"

# Flutter
alias frn="flutter run"
alias fcl="flutter clean"
alias fpg="flutter pub get"
alias fcrun="fcl && fpg && frn"

# Node
alias pnpx="pnpm exec"
alias psu="pnpm self-update"
alias pmg="pnpm prisma generate"

# mySQL
alias stopsql="brew services stop mysql"
alias startsql="brew services start mysql"

# Python
alias pip="pip3"

# ZSH
alias reload="source ~/.zshrc && clear"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias tmuxconfig="code ~/.tmux.conf"

# TMUX
alias ide='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50'

# Misc
alias c="clear"
alias st="stree ."
alias cod="code ."
alias rmnm="rm -rf node_modules"
alias iphone="open -a simulator"

# Laravel
alias migrate="php artisan migrate"
alias val="valet link && valet open"
alias mfs="php artisan migrate:fresh --seed"

# Web Framework
alias ci4="composer create-project codeigniter4/appstarter --no-dev $1"

# Java Spring Maven
alias sbsit="mvn-color spring-boot:run -Dspring-boot.run.profiles=sit"
alias sbstg="mvn-color spring-boot:run -Dspring-boot.run.profiles=stg"
alias sbprd="mvn-color spring-boot:run -Dspring-boot.run.profiles=prd"
alias sbdev="mvn-color spring-boot:run -Dspring-boot.run.profiles=dev"

# Redis CLI

# Change Directory
alias kcc="cd $HOME/work/KAnggara/scc"
alias wp="cd $HOME/work"
alias yt="cd $HOME/YouTube"
alias dot="cd $HOME/dotfile"
alias ply="cd $HOME/work/playground"
alias pwa="cd $HOME/work/PakaiWA"
alias ka="cd $HOME/work/KAnggara"
alias ids="cd $HOME/work/IDScript"
alias 75="cd $HOME/work/KAnggara75"
alias eday="cd $HOME/work/KAnggara75/eday"

# JetBrains Apps
alias ws='open -na "WebStorm.app" --args nosplash "$@"'
alias goland='open -na "GoLand.app" --args nosplash "$@"'
alias idea='open -na "IntelliJ IDEA.app" --args nosplash "$@"'

# -------------------------------------
# OS SPECIFIC ALIAS & ENV
# -------------------------------------
case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
darwin)
	alias kaad="/usr/bin/ssh-add --apple-use-keychain ~/.ssh/KAnggara"
	alias sadd="/usr/bin/ssh-add --apple-use-keychain ~/.ssh/KAnggara75"
	alias dnsclear="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
	alias chdns="networksetup -getdnsservers Wi-Fi"
	alias jdk="export JAVA_HOME='$HOME/dev/openjdk/Contents/Home'"
	alias jdk17="export JAVA_HOME='$HOME/dev/openjdk17/Contents/Home'"
	alias jdk21="export JAVA_HOME='$HOME/dev/openjdk21/Contents/Home'"
	alias jdk23="export JAVA_HOME='$HOME/dev/openjdk23/Contents/Home'"

	export PGPASSWORD="password"
	alias posql="psql -h 127.0.0.1 -p 5432 -U postgresql -d $1"
	export PNPM_HOME="$HOME/Library/pnpm"
	export JAVA_HOME="$HOME/dev/openjdk/Contents/Home"
	export GRALVM_HOME="$HOME/dev/openjdk/Contents/Home"
	export SOLACE_JMS="$HOME/dev/solace-jms/bin"
	export LIBPQ="/opt/homebrew/opt/libpq/bin"
	export MYSQL_CLIENT="/opt/homebrew/opt/mysql-client@8.4/bin"

	# NVM & bun
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
	[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

	# Docker completion (Mac)
	fpath=("$HOME/.docker/completions" $fpath)
	;;
linux)
	alias k="kubectl $@"
	alias kga="kubectl get all"
	alias kgp="kubectl get pod $@"
	alias kaad="/usr/bin/ssh-add ~/.ssh/KAnggara"
	alias sadd="/usr/bin/ssh-add ~/.ssh/KAnggara75"
	alias nnginx="sudo certbot --nginx -d $1"

	export KUBECONFIG="$HOME/.kube/config"
	export LIBPQ="/usr/local/opt/libpq/bin"
	export MYSQL_CLIENT="/usr/local/opt/mysql-client/bin"

	# NVM
	[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
	[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
	;;
esac

# -------------------------------------
# AUTH & SERVICE URL
# -------------------------------------

# -------------------------------------
# PATH HANDLING: Unique, clean, ordered
# -------------------------------------
typeset -U path
ZSH_PATHS=(
	"$MY_BIN"
	"$GOPATH/bin"
	"$BUN_INSTALL"
	"$MONGO_HOME"
	"$LIBPQ"
	"$MYSQL_CLIENT"
	"$DART_PUB"
	"$SBIN_PATH"
	"$RUBY_PATH"
	"$NODE_PATH"
	"$MAVEN_HOME"
	"$FLUTTER_HOME"
	"$COMPOSER_HOME/bin"
	"$COMPOSER_HOME/vendor/bin"
	"$ANDROID_HOME/tools"
	"$ANDROID_HOME/cmdline-tools/latest/bin"
	"$ANDROID_HOME/platform-tools"
	"$NVM_DIR"
	"$PNPM_HOME"
	"$IDEA_HOME"
	"$SOLACE_JMS"
	"$PATH"
)
for d in $ZSH_PATHS; do
	[[ -d "$d" ]] && path+=("$d")
done
export PATH

# -------------------------------------
# DOCKER COMPLETIONS (autoload once)
# -------------------------------------
autoload -Uz compinit && compinit

# -------------------------------------
# PROMPT CONFIG
# -------------------------------------
prompt_context() {}
prompt_dir() {
	if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" ]]; then
		prompt_segment red white "$(shrink_path -f)"
	else
		prompt_segment blue white "$(shrink_path -f)"
	fi
}

if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
	# Deteksi: Bukan SSH
	if [ "${TERM_PROGRAM:-}" != "tmux" ] && [ "${TERM_PROGRAM:-}" != "WarpTerminal" ]; then
		# Cek apakah ada minimal 1 tmux session
		last_session=$(tmux ls 2>/dev/null | tail -n 1 | cut -d: -f1)
		if [ -n "$last_session" ]; then
			tmux attach-session -t "$last_session"
		else
			tmux new-session -s KA
		fi
	fi
fi

# bun completions
[ -s "/Users/k/.bun/bin/_bun" ] && source "/Users/k/.bun/bin/_bun"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
