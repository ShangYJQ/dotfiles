#!/usr/bin/env bash

killall swayidle 2>/dev/null

swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 600 'niri msg action power-off-monitors' \
    resume      'niri msg action power-on-monitors' \
    timeout 1200 'systemctl suspend' \
    before-sleep 'swaylock -f'
