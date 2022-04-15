#!/usr/bin/env bash
# Copyright (c) 2022-present Kelvin Anggara <kanggara@kanggara.me>(https://kanggara.me)

# Project:    KAnggara Tmux Theme
# Repository: https://github.com/kanggara75/ka-tmux
# License:    MIT

# References:
#   https://tmux.github.io

KA_VERSION=0.1.0
# Load Config 
KA_COLOR="src/color.conf"
KA_STATUS_BAR="src/status-bar.conf"
KA_STATUS_BAR_NO_FONT="src/status-bar-no-font.conf"
# Option
KA_NO_FONT_OPTION="@ka_no_font"
KA_DATE_FORMAT="@ka_date_format"
KA_STATUS_BAR_OPTION="@ka_show_status_content"
_current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

__cleanup() {
  unset -v KA_COLOR KA_VERSION
  unset -v KA_STATUS_BAR KA_STATUS_BAR_NO_FONT
  unset -v KA_STATUS_BAR_OPTION KA_NO_FONT_OPTION
  unset -v KA_STATUS_BAR_DATE_FORMAT
  unset -v _current_dir
  unset -f __load __cleanup
  tmux set-environment -gu KA_TIME_FORMAT
  tmux set-environment -gu KA_DATE_FORMAT
}

__load() {
  tmux source-file "$_current_dir/$KA_COLOR"

  local status_content=$(tmux show-option -gqv "$KA_STATUS_BAR_OPTION")
  local no_patched_font=$(tmux show-option -gqv "$KA_NO_FONT_OPTION")
  local date_format=$(tmux show-option -gqv "$KA_STATUS_BAR_DATE_FORMAT")

  if [ "$(tmux show-option -gqv "clock-mode-style")" == '12' ]; then
    tmux set-environment -g KA_TIME_FORMAT "%I:%M %p"
  else
    tmux set-environment -g KA_TIME_FORMAT "%H:%M:%S"
  fi

  if [ -z "$date_format" ]; then
    tmux set-environment -g KA_DATE_FORMAT "%Y-%m-%d"
  else
    tmux set-environment -g KA_DATE_FORMAT "$date_format"
  fi

  if [ "$status_content" != "0" ]; then
    if [ "$no_patched_font" != "1" ]; then
      tmux source-file "$_current_dir/$KA_STATUS_BAR"
    else
      tmux source-file "$_current_dir/$KA_STATUS_BAR_NO_FONT"
    fi
  fi
}

__load
__cleanup
