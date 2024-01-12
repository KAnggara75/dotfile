# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"
plugins=(git zsh-autosuggestions shrink-path)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source $ZSH/oh-my-zsh.sh

# Adb and android tools
export SBIN_PATH="/usr/local/sbin"
export RUBY_PATH="/usr/local/opt/ruby/bin"
export NODE_PATH="/usr/local/opt/node@20/bin"
# User PATH
export PNPM_HOME="~/Library/pnpm"
export ANDROID_HOME="~/Library/Android/sdk"
export COMPOSER_HOME="~/.composer/vendor/bin"
# Personal dev PATH
export DART_PUB="~/.pub-cache/bin"
export MAVEN_HOME="~/dev/mvn/bin"
export FLUTTER_HOME="~/dev/flutter/bin"
export JAVA_HOME="~/dev/openjdk/Contents/Home"
# Update PATH
export PATH=$DART_PUB:$SBIN_PATH:$RUBY_PATH:$NODE_PATH:$JAVA_HOME:$JAVA_HOME/bin:$PNPM_HOME:$MAVEN_HOME:$FLUTTER_HOME:$COMPOSER_HOME:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# Node Compiler Cofig
export LDFLAGS="-L/usr/local/opt/node@20/lib"
export CPPFLAGS="-I/usr/local/opt/node@20/include"

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
alias gcq="git checkout qa"
alias gcmm="git commit -m "$1""
alias gcr="git checkout release"
alias gcms="git commit -S -m "$1""
alias gcma="git commit --amend -S -m "$1""
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
alias pnpx="pnpm exec"

#mySQL Alias
alias stopsql="brew services stop mysql"
alias startsql="brew services start mysql"

# Python Virtual Env
alias pip="pip3"
# alias python="python3"
alias act="source .env/bin/activate"
alias venv="python3 -m venv .env && source .env/bin/activate"

# ZSH Alias
alias reload="source ~/.zshrc && clear"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias tmuxconfig="code ~/.tmux.conf"
# alias sadd="/usr/bin/ssh-add -K ~/.ssh/KAnggara75-GitHub"
alias sadd="/usr/bin/ssh-add --apple-use-keychain ~/.ssh/KAnggara75-GitHub"

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
alias upv='/bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/KAnggara75/e7f3d7f7c114c1348fec3b2c22f7041e/raw/e8260cbf0b5d5ea859703da35edcfe3b0f314580/GitVersion.sh)"'

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
alias wp="cd $HOME/work"
alias da="cd /Volumes/DATA/"
alias dot="cd $HOME/dotfile"
alias wo="cd /Volumes/DATA/Work"
alias ka="cd /Volumes/DATA/Work/KAnggara"
alias 75="cd /Volumes/DATA/Work/KAnggara75"
alias hk="cd ~/work/KAnggara75/HK"
alias pwa="cd ~/work/PakaiWA"
alias ids="cd ~/work/IDScript"

# my Project Folder
alias alif="cd $HOME/work/KAnggara/alif"
alias hackintosh="cd $HOME/Work/projectku/KAnggara75/hackintosh"
alias eday="cp $HOME/Pictures/Photo\ Booth\ Library/Pictures/* /Volumes/DATA/Work/KAnggara75/everyday/2022/"

alias tms="cd $HOME/work/ATMC/tms_package/ && ./tms_package.sh"
alias efts="cd /Volumes/DATA/efts/atm"
alias wa="cd ~/work/wa"

# SNV Alias
export SVN_EDITOR=code
alias sup="svn up"
alias sst="svn st"
alias slog="svn log -l 10"
alias msit="svn merge https://wakatobi.telkomsigma.co.id/svn/JALIN%20-%20Pengadaan%20Solusi%20e-Channel%20Platform_SourceCode/atm-link/trunk/ -c $1"
alias muat="svn merge https://wakatobi.telkomsigma.co.id/svn/JALIN%20-%20Pengadaan%20Solusi%20e-Channel%20Platform_SourceCode/atm-link/branches/SIT/ -c $1"

# Spring boot alias
# alias spring-run="export $(cat .env | xargs) && mvn spring-boot:run"

# fix ssh agent
# eval "$(ssh-agent -s)" 2>/dev/null
# ssh-add -K ~/.ssh/KAnggara75-GitHub 2>/dev/null

prompt_context() {}
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment red black
    else
      prompt_segment blue black
    fi
    echo -n "${ref/refs\/heads\//⭠ }$dirty"
  fi
}
prompt_dir() {
  prompt_segment cyan black $(shrink_path -f)
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
