#!/bin/bash
nsname=$1
touch lock/$1.lock
mount --bind lock/$1.lock /var/run/rpcbind.lock
ip netns exec $1 rpcbind