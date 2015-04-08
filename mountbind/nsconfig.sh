#!/bin/bash
if [ $# -lt 2 ];
	then
		echo "Script usage: ./nsconfig.sh [NSname] [start/stop]"
		exit 1
fi

nsname=$1
nslist=$(ip netns list)

if [ -z $nsname ]; then 
		echo "Please enter namespace name"
		exit 1
fi

if [ $2 == "stop" ]; then
		pid=$(cat log.file | grep $nsname)
		array=( $pid )
		rpcpid = ${array[1]}
		echo ${array[1]}
		kill -9 ${array[1]}
		umount $nsname.lock /var/run/rpcbind.lock
		rm $nsname.lock #deleting .lock file
		sed -i "/^$nsname/d" "log.file" #deleting information in logs
		echo "Rpcbind in NS $nsname successfully stopped"
		exit 1
fi

touch $nsname.lock
mount --bind $nsname.lock /var/run/rpcbind.lock
ip netns exec $nsname rpcbind

count=0
for proc in `pgrep "^rpcbind"`; do 
	let count=count+1
    echo $proc
done

cnt=0
for proc in `pgrep "^rpcbind"`; do 
	let cnt=cnt+1
    if [ $cnt == $count ]; then
    	echo "$nsname $proc" >> log.file
    fi
done 

