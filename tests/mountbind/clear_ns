#!/bin/bash

netns=$(ip netns list)
echo $netns

for j in $netns
	do
		echo delete $j namespace
		ip netns delete $j
	done