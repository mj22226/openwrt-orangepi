#!/bin/bash
. /lib/functions/system.sh
board=$(board_name)
if [[ ${board} == rockchip,rk3588s-orangepi-cm5 ]]; then
	declare -A led_map=(
		["lan2"]="eth2"
		["lan1"]="eth1"
		["wan"]="eth0"
	)
	for led in "${!led_map[@]}"; do
		interface=$(ls /sys/class/net/ | grep -E "${led_map[$led]}" | sed -n 1p)
		echo netdev > "/sys/class/leds/$led/trigger"
		echo "$interface" > "/sys/class/leds/$led/device_name"
		echo 1 > "/sys/class/leds/$led/tx"
		echo 1 > "/sys/class/leds/$led/rx"
		echo 1 > "/sys/class/leds/$led/link"
	done
fi