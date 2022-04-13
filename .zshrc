# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/k/.oh-my-zsh"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export TERM=screen-256color

ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"

plugins=(git zsh-autosuggestions)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source $ZSH/oh-my-zsh.sh

# Adb and android tools
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
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
# ls
TREE_IGNORE="cache|log|logs|node_modules|vendor"
alias ls=' exa --group-directories-first'
alias la=' ls -a'
alias ll=' ls --git -l'
alias lt=' ls --tree -D -L 2 -I ${TREE_IGNORE}'

# Git Custom alisa
alias ghpage="git add . && git status && git commit -m 'Some descriptive commit message' && git push origin master && git checkout gh-pages && git rebase master && git push origin gh-pages && git checkout master"
alias gcr="git checkout release"
alias ghcreate="gh repo create $1 --public"
alias gcmm="git commit -m "$1""
alias add="git add $1"

# Flutter alias
alias fpg="flutter pub get"
alias frn="flutter run"
alias fcl="flutter clean"
alias fcrun="fcl && fpg && frn"
alias fcr="flutter create $1"

#mySQL Alias
alias startsql="brew services start mysql"
alias stopsql="brew services stop mysql"

# Python Virtual Env
alias venv="python -m venv env && source env/bin/activate"
alias act="source env/bin/activate"
alias pip="pip3"

# ZSH Alias
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias reload="source ~/.zshrc"

# TMUX ALIAS
alias :new="tmux new -s $1"
alias :mm='f(){ if [ -z "$1" ]; then tmux a; else tmux new-session -s "$1"; fi; }; f'
alias att='f(){ if  (tmux a -t "$1" | grep -q TMUX) 2>/dev/null; then tmux a -t "$1"; else tmux switch -t "$1"; fi; }; f'
alias ide='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50'

# Cusom Alias
alias c="clear"
alias nv="nvim $1"
alias new="touch $1"
alias q="exit"
alias mku="cd /Users/k/Work/kuroject_mac"
alias kuroject="cd /Volumes/DATA/kuroject"
alias 2022="cd /Volumes/DATA/Downloads/2022"
alias kan="cd /Volumes/DATA/kuroject/KAnggara"
alias ka75="cd /Volumes/DATA/kuroject/KAnggara75"
alias gotmp-web="/Users/k/Work/kuroject_mac/KAnggara/gotmp/web"
alias gotmp-app="/Users/k/Work/kuroject_mac/KAnggara/gotmp/app"

# api-whatsapp
alias wapi="cd /Users/k/Work/kuroject_mac/wapi"

# Thesis Project alias
alias thesis-web="cd /Users/k/Work/kuroject_mac/KAnggara75/TheSiS/web"
alias thesis-app="cd /Users/k/Work/kuroject_mac/KAnggara75/TheSiS/app"
alias iphone="open -a simulator"

# my Project Folder
alias sil="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/docs"
alias siapi="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/api"
alias siapp="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/app"
alias siuno="cd /Volumes/DATA/kuroject/KAnggara75/SiListrik/uno"

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
    prompt_segment blue $CURRENT_FG '%25<..<%~%<<'
}