#!/usr/bin/env bash

get_battery() {
  local percent=""
  local state=""
  local icon="󰁹"

  if [ "$(uname -s)" = "Darwin" ]; then
    local batt_info
    batt_info="$(pmset -g batt 2>/dev/null)"
    percent="$(echo "$batt_info" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
    if echo "$batt_info" | grep -qi "charging" && ! echo "$batt_info" | grep -qi "discharging"; then
      state="charging"
    elif echo "$batt_info" | grep -qi "AC attached"; then
      state="charging"
    fi
  elif [ -d /sys/class/power_supply ]; then
    for bat in /sys/class/power_supply/BAT* /sys/class/power_supply/battery; do
      if [ -f "$bat/capacity" ]; then
        percent="$(cat "$bat/capacity" 2>/dev/null)"
        [ -f "$bat/status" ] && grep -qi "charging" "$bat/status" && state="charging"
        break
      fi
    done
  fi

  [ -z "$percent" ] && return

  if [ "$state" = "charging" ]; then
    icon="󰂄"
  else
    if [ "$percent" -ge 90 ]; then
      icon="󰁹"
    elif [ "$percent" -ge 80 ]; then
      icon="󰂂"
    elif [ "$percent" -ge 70 ]; then
      icon="󰂁"
    elif [ "$percent" -ge 60 ]; then
      icon="󰂀"
    elif [ "$percent" -ge 50 ]; then
      icon="󰁿"
    elif [ "$percent" -ge 40 ]; then
      icon="󰁾"
    elif [ "$percent" -ge 30 ]; then
      icon="󰁽"
    elif [ "$percent" -ge 20 ]; then
      icon="󰁼"
    elif [ "$percent" -ge 10 ]; then
      icon="󰁻"
    else
      icon="󰁺"
    fi
  fi

  printf "%s %s%%" "$icon" "$percent"
}

get_battery
