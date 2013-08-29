#!/bin/bash

# toggle the mode to the given ID
dbus-send --type=method_call --dest=org.seul.Xboxdrv  /org/seul/Xboxdrv/ControllerSlots/0 org.seul.Xboxdrv.Controller.SetConfig int32:$1

# Default LED to flash once to indicate switch
LED_ID=15

# Set the LED to rotate in command mode
[[ $1 == "1" ]] && LED_ID=10

# Set the indicator LED
dbus-send --type=method_call --dest=org.seul.Xboxdrv  /org/seul/Xboxdrv/ControllerSlots/0 org.seul.Xboxdrv.Controller.SetLed int32:$LED_ID

exit 0
