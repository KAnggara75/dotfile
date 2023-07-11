# Path to your oh-my-zsh installation.
export ZSH="/Users/k/.oh-my-zsh"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=xterm-256color

ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"
plugins=(git zsh-autosuggestions shrink-path)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source $ZSH/oh-my-zsh.sh

# Adb and android tools
export MAVEN_HOME="$HOME/dev/apache-maven-3.8.6/bin"
# export COMPOSER_HOME="$HOME/.composer/vendor/bin"
# export COMPOSER_HOME="$HOME/.composer/vendor/bin/vendor/bin"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export JAVA_HOME="$HOME/dev/jdk/Contents/Home"
export NODE_HOME="/usr/local/opt/node@18/bin"
export FLUTTER_HOME="$HOME/dev/flutter/bin"
export PNPM_HOME="$HOME/Library/pnpm"

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"

export PATH=$MAVEN_HOME:$PATH
export PATH=$NODE_HOME:$PATH
export PATH=$JAVA_HOME:$PATH
export PATH=$PNPM_HOME:$PATH
export PATH=$FLUTTER_HOME:$PATH
# export PATH=$COMPOSER_HOME:$PATH
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# Node Compiler Cofig
export LDFLAGS="-L/usr/local/opt/node@18/lib"
export CPPFLAGS="-I/usr/local/opt/node@18/include"

# For tkinter
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# exa alias
TREE_IGNORE="cache|log|logs|node_modules|vendor"

alias ls='exa --group-directories-first'
alias la='exa --group-directories-first -lah'
alias ll='exa --group-directories-first --git -l'
alias lt='exa --group-directories-first --tree -D -L 3 -I ${TREE_IGNORE}'

# ADB alias
alias adbwifi='adb tcpip 5555'

# Git Custom alisa
alias add="git add $1"
alias diff="git diff $1"
alias gcmm="git commit -m "$1""
alias gchr="git checkout release"
alias gcms="git commit -S -m "$1""
alias gcr="gh repo create $1 --public"
alias gv="gitversion | grep NuGetVersionV2"
alias ghpage="git add . && git status && git commit -m 'Some descriptive commit message' && git push origin master && git checkout gh-pages && git rebase master && git push origin gh-pages && git checkout master"

# Flutter alias
alias frn="flutter run"
alias fcl="flutter clean"
alias fpg="flutter pub get"
alias fcr="flutter create $1"
alias fcrun="fcl && fpg && frn"

# node js
# alias npm="pnpm $1"
# alias npx="pnpm dlx"
alias pnpx="pnpm dlx"

#mySQL Alias
alias stopsql="brew services stop mysql"
alias startsql="brew services start mysql"

# Python Virtual Env
alias pip="pip3"
# alias python="python3"
alias act="source .env/bin/activate"
alias venv="python3 -m venv .env && source .env/bin/activate"

# ZSH Alias
alias reload="source ~/.zshrc"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias tmuxconfig="code ~/.tmux.conf"
# alias sadd="/usr/bin/ssh-add -K ~/.ssh/KAnggara75-GitHub"
alias sadd="/usr/bin/ssh-add --apple-use-keychain ~/.ssh/KAnggara75-GitHub"

# TMUX ALIAS
alias ide='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50'

# Custom Alias
alias c="clear"
alias q="exit"
alias nv="nvim $1"
alias new="touch $1"
alias iphone="open -a simulator"

# Laravel alias
alias artisan="php artisan $1"
alias migrate="php artisan migrate"
alias val="valet link && valet open"
alias mfs="php artisan migrate:fresh --seed"

# Web Framework alias
alias ci4="composer create-project codeigniter4/appstarter --no-dev $1"

# DNS cache Clear
alias dnsclear="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# =================================================================================================
# Change Directory
alias wp="cd /Users/k/work"
alias da="cd /Volumes/DATA/"
alias dot="cd /Users/k/dotfile"
alias wo="cd /Volumes/DATA/Work"
alias ka="cd /Volumes/DATA/Work/KAnggara"
alias 75="cd /Volumes/DATA/Work/KAnggara75"

# my Project Folder
alias alif="cd /Users/k/work/KAnggara/alif"
alias hackintosh="cd /Users/k/Work/projectku/KAnggara75/hackintosh"
alias eday="cp /Users/k/Pictures/Photo\ Booth\ Library/Pictures/* /Volumes/DATA/Work/KAnggara75/everyday/2022/"

alias tms="cd /Users/k/work/ATMC/tms_package/ && ./tms_package.sh"
alias efts="cd /Volumes/DATA/efts/atm"
alias wa="cd /Users/k/work/wa"

# fix ssh agent
# eval "$(ssh-agent -s)" 2>/dev/null
# ssh-add -K ~/.ssh/KAnggara75-GitHub 2>/dev/null

# eval "$(pyenv init -)"

prompt_context() {}
prompt_dir() {
  prompt_segment blue $CURRENT_FG $(shrink_path -f)
}

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

if [ "$TERM_PROGRAM" != tmux ]; then
  read -q T\?"We are not in TMUX, Let's get in? "
  clear
  if [ $T = "y" ]; then
    if (tmux ls 2>/dev/null) | tail -1 | grep -q "windows"; then
      tmux a -t $(tmux ls | tail -1 | cut -d : -f1)
    else
      tmux new -s KA
    fi
  else
    clear
  fi
fi
