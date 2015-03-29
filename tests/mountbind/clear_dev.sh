#!/bin/bash
iwconfig
echo Type your devices you WANT TO delete
read devices
echo Will be deleting: $devices

for i in $devices
	do
		echo deleting device $i
		ip link delete $i
	done
exit 0
