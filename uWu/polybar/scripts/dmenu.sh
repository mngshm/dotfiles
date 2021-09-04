#!/bin/sh

# A dmenu wrapper script for system functions.

# For non-systemd init systems.
case "$(readlink -f /sbin/init)" in
	*runit*) hib="sudo -A zzz" ;;
	*openrc*) reb="sudo -A openrc-shutdown -r"; shut="sudo -A openrc-shutdown -p 0" ;;
esac

cmds="\
󱎜  lock		slimlock
󰁬  leave bsp	kill -TERM $(pkill bspwm sxhkd)
󱋑  hibernate	slock ${hib:-systemctl suspend-then-hibernate -i}
󰻹  reboot	${reb:-sudo -A reboot}
󰧵  shutdown	${shut:- sudo shutdown now}
󰔱  display off 	 xset dpms force off"

choice="$(echo "$cmds" | cut -d'	' -f 1 | dmenu -p BYE -l 7 )" || exit 1

`echo "$cmds" | grep "^$choice	" | cut -d '	' -f2-`
