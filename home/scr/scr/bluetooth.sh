#!/bin/bash

systemctl status bluetooth || sudo systemctl start bluetooth
bluetoothctl power on
mode=$(echo -e 'Connect\nNew Connection\nDisconnect' | rofi -i -p 'bluetooth' -dmenu)

if [ "$mode" = "Connect" ]; then
  selection=($(bluetoothctl devices | awk '{print $2,$3}' | rofi -i -p "Connect:" -dmenu))
  bluetoothctl connect ${selection[0]} && txt="Bluetooth connect to " || txt="Can't connect to "
  notify-send "BlueTooth" "$txt${selection[1]}"
elif [ "$mode" = "New Connection" ]; then
  st -e bluetoothctl
elif [ "$mode" = "Disconnect" ]; then
  selection=($(bluetoothctl devices | awk '{print $2,$3}' | rofi -i -p "Disconnect:" -dmenu))
  bluetoothctl disconnect ${selection[0]} && notify-send "BlueTooth" "Buletooth Disconnect from ${selection[1]}"
fi
