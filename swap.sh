#!/bin/bash
# KAnggara git signature setup
# url: https://github.com/KAnggara75/dotfile

RAM=$(awk '$1~/MemTotal:/ {print $2/1024/1024}' /proc/meminfo)

if[ "$RAM" >= 8]; then
  echo $RAM
fi
