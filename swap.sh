#!/bin/bash
# KAnggara git signature setup
# url: https://github.com/KAnggara75/dotfile

RAM=$(awk '$1~/MemTotal:/ {print $2;}' /proc/meminfo)

echo $RAM
