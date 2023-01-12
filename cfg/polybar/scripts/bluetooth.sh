#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo "%{T3}%{F#e576cb}󰂯%{F#e576cb}%{T0}"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo "%{T3}󰂯%{T0}"
  fi
  echo "󰂯"
fi

