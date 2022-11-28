if [ "$TERM_PROGRAM" != tmux ];
then
  read -q T\?"We are not in TMUX, Let's get in? "
  if [ $T = "y" ]
  then
    clear
    if (tmux ls > /dev/null) | sort -Vk3 | tail -1 | grep -q "windows" ;
    then
      tmux a -t $(tmux ls | sort -Vk3 | tail -1 | awk '{print $1}')
    else
      tmux new -s KA
    fi
  else
    clear
  fi
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/k/.oh-my-zsh"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export TERM=screen-256color

ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"

plugins=(git zsh-autosuggestions shrink-path)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source $ZSH/oh-my-zsh.sh

# Adb and android tools
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export GPG_TTY=$(tty)
export PATH=$HOME/bin:$PATH
export PATH=$JAVA_HOME/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/Users/k/.composer/vendor/bin:$PATH
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH="/usr/local/opt/php@8.0/bin:$PATH"
export PATH="/usr/local/opt/php@8.0/sbin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:/Users/k/dev/flutter/bin"
export PATH="/usr/local/opt/node@16/bin:$PATH"

# exa alias
TREE_IGNORE="cache|log|logs|node_modules|vendor"
alias ls=' exa --group-directories-first'
alias la=' ls -lah'
alias ll=' ls --git -l'
alias lt=' ls --tree -D -L 3 -I ${TREE_IGNORE}'

# ADB alias
alias adbwifi='adb tcpip 5555'

# Git Custom alisa
alias ghpage="git add . && git status && git commit -m 'Some descriptive commit message' && git push origin master && git checkout gh-pages && git rebase master && git push origin gh-pages && git checkout master"
alias gcr="git checkout release"
alias ghcreate="gh repo create $1 --public"
alias gcmm="git commit -m "$1""
alias gcms="git commit -S -m "$1""
alias add="git add $1"
alias diff="git diff $1"
alias gv="gitversion|grep NuGetVersionV2"

# Flutter alias
alias fpg="flutter pub get"
alias frn="flutter run"
alias fcl="flutter clean"
alias fcrun="fcl && fpg && frn"
alias fcr="flutter create $1"

# node js 
alias npm="pnpm $1"

#mySQL Alias
alias startsql="brew services start mysql"
alias stopsql="brew services stop mysql"

# Python Virtual Env
alias venv="python3 -m venv env && source env/bin/activate"
alias act="source env/bin/activate"
alias pip="pip3"

# ZSH Alias
alias tmuxconfig="code ~/.tmux.conf"
alias ohmyzsh="code ~/.oh-my-zsh"
alias zshconfig="code ~/.zshrc"
alias reload="source ~/.zshrc"

# TMUX ALIAS
alias :new="tmux new -s $1"
alias :mm='f(){ if [ -z "$1" ]; then tmux a; else tmux new-session -s "$1"; fi; }; f'
alias att='f(){ if  (tmux a -t "$1" | grep -q TMUX) 2>/dev/null; then tmux a -t "$1"; else tmux switch -t "$1"; fi; }; f'
alias ide='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50'

# Custom Alias
alias c="clear"
alias q="exit"
alias nv="nvim $1"
alias new="touch $1"
alias data="cd /Volumes/DATA/"

alias pku="cd /Users/k/Work/projectku"
alias ka="cd /Users/k/Work/projectku/kanggara"
alias 75="cd /Users/k/Work/projectku/kanggara75"
alias mku="cd /Users/k/Work/kuroject_mac"
alias wo="cd /Volumes/DATA/Work"


# Laravel alias
alias artisan="php artisan $1"
alias mfs="php artisan migrate:fresh --seed"

# api-whatsapp
alias wapi="cd /Users/k/Work/projectku/wapi"

# Thesis Project alias
alias thesis="cd /Users/k/Work/projectku/kanggara75/thesis"
alias iphone="open -a simulator"

# my Project Folder
alias sil="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/docs"
alias siapi="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/api"
alias siapp="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/app"
alias siuno="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/uno"
alias hackintosh="cd /Users/k/Work/projectku/KAnggara75/hackintosh"

# Web Framework alias
alias ci4="composer create-project codeigniter4/appstarter --no-dev $1"

# DNS cache Clear
alias dnsclear="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# PHP Change version
alias sp80="brew unlink php && brew link --overwrite --force php@8.0"
alias sp81="brew unlink php && brew link --overwrite --force php@8.1"

# eval "$(pyenv init -)"
prompt_context () {}
prompt_dir() {
    prompt_segment blue $CURRENT_FG $(shrink_path -f)
}

export PNPM_HOME="/Users/k/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

