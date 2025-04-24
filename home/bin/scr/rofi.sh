#!/usr/bin/env bash

# 打印菜单
call_menu() {
	echo -e 'pwd\njourney\nbluetooth\nsleep\nhibernate\npoweroff\nreboot'
	# [ "$(sudo docker ps | grep v2raya)" ] && echo ' close v2raya' || echo ' open v2raya'
	[ "$(ps aux | grep picom | grep -v 'grep\|rofi\|v')" ] && echo 'close picom' || echo 'open picom'
}

# 执行菜单
execute_menu() {
	case $1 in
		'pwd')
			rofi -p 'passwd' -dmenu| python -c "$(sudo cat $HOME/scr/pwd)" |xargs xdotool type
			;;
		'journey')
            ~/.local/bin/jy rofi
			;;
		'bluetooth')
			~/scr/bluetooth.sh &
			;;
		'sleep')
            ~/scr/blurlock.sh
			systemctl suspend &
			;;
		'hibernate')
            ~/scr/blurlock.sh
			systemctl hibernate &
			;;
		'poweroff')
			shutdown now
			;;
		'reboot')
			reboot
			;;
		'open picom')
			coproc (picom --experimental-backends > /dev/null 2>&1)
			;;
		'close picom')
			killall picom
			;;
		*)
            if [ "$input" != "" ]; then
                notify-send "$(fish -c "$input")"
            fi
			;;
	esac
}

input="$(call_menu | rofi -dmenu -matching prefix -p "shotcut")"
execute_menu "$input"
