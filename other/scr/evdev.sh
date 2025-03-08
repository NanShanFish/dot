#!/bin/bash
if [ "$1" ]; then
	file="$1"
else
	file="/usr/share/X11/xkb/keycodes/evdev"
fi

sed -i 's/^\t<CAPS> = [0-9]*;$/\t<CAPS> = 9;/' "$file"
sed -i 's/^\t<ESC> = [0-9]*;$/\t<ESC> = 37;/' "$file"
sed -i 's/^\t<LCTL> = [0-9]*;$/\t<LCTL> = 66;/' "$file"
