#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar
# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown


echo "---" | tee -a /tmp/example.log
polybar example 2>&1 | tee -a /tmp/example.log & disown
# polybar bottom 2>&1 | tee -a /tmp/bottom.log & disown
echo "Bars launched..."
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
	# MONITOR=$m polybar --reload bottom &
  done
else
  polybar --reload example &
fi
# case $desktop in

    # i3|/usr/share/xsessions/i3)
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-i3 -c ~/.config/polybar/config.ini &
    #   done
    # else
    # polybar --reload mainbar-i3 -c ~/.config/polybar/config.ini &
    # fi
    # second polybar at bottom
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-i3-extra -c ~/.config/polybar/config.ini &
    #   done
    # else
    # polybar --reload mainbar-i3-extra -c ~/.config/polybar/config.ini &
    # fi
    ;;
# esac
