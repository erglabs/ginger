#!/bin/bash
# notes:
# this file is being run on x11 startup
# please modify it to your hearts content and put it in as "/etc/X11/xinit/xinitrc.d/55-layout.sh"

# please merge if not merged by parent script
xrdb -merge ~/.Xresources

# numlock on on start
numlockx on

# 4x4k wih scalling (old version, discouraged)
# xrandr --output HDMI-0 --mode 1920x1080 --scale 2x2 --pos 3840x0 --rotate normal --output DP-5 --mode 1920x1080 --scale 2x2 --pos 0x0 --rotate normal --output DP-0 --mode 3840x2160 --pos 3840x2160 --rotate normal --output DP-1 --off --output DP-2 --primary --mode 3840x2160 --pos 0x2160 --rotate normal --output DP-3 --off

# another one, alternative version to the one below
# 4x4k projected
#xrandr --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-0 --mode 3840x2160 --pos 3840x2160 --rotate normal --output DP-1 --off --output DP-2 --primary --mode 3840x2160 --pos 0x2160 --rotate normal --output DP-3 --off --output DP-4 --off --output DP-5 --mode 1920x1080 --pos 0x0 --rotate normal

#keyboard map shenanigans
setxkbmap -model pc104 -layout 'pl,ru' -variant ',phonetic_winkeys' -option grp:alt_space_toggl
setxkbmap -option numpad:mac

# 4x4k projected, primary
xrandr --output HDMI-0 --mode 1920x1080 --scale 2x2 --pos 3840x0 --rotate normal --output DP-5 --mode 1920x1080 --scale 2x2 --pos 0x0 --rotate normal --output DP-0 --mode 3840x2160 --pos 3840x2160 --rotate normal --output DP-1 --off --output DP-2 --primary --mode 3840x2160 --pos 0x2160 --rotate normal --output DP-3 --off

