#!/bin/bash

xrandr --output DP-2 --mode 1920x1080 --rotate left --pos 1920x0 --crtc 1
xrandr --output HDMI-1 --mode 1920x1080 --pos 0x420 --crtc 2
xrandr --output eDP-1 --mode 1366x768 --pos 3000x1152 --crtc 0

