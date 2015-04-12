#!/bin/bash
start() {
	touch /tmp/"$nsname".lock	
	touch /tmp/"$nsname".sock
	mount --bind /tmp/"$nsname".lock /var/run/rpcbind.lock
	mount --bind /tmp/"$nsname".sock /var/run/rpcbind.sock
	ip netns exec $nsname rpcbind
	pid=$(pidof rpcbind | awk '{print $1}')
	echo -n $pid >> /tmp/"$nsname".pid
	logger "rpcbind in "$nsname" namespace started"
}

stop() {
	pid=$(cat /tmp/"$nsname".pid)
	kill -ABRT $pid
	umount /tmp/"$nsname".lock
	umount /tmp/"$nsname".sock
	rm /tmp/"$nsname".lock
	rm /tmp/"$nsname".sock
	rm /tmp/"$nsname".pid
	logger "rpcbind in "$nsname" namespace stopped"
}

###main logic###
if [ $# -lt 2 ];
	then
		echo "Script usage: ./nsconfig.sh [NSname] [start/stop]"
		exit 1
fi

nsname=$1
usage=$2
if [ -z $nsname ]; then 
		echo "Please enter namespace name"
		exit 1
fi

case "$usage" in
	"start")
		start
		;;
	"stop")
		stop
		;;
	*)
		echo "Usage ./nsconfig [NSname] [start/stop]"
		exit 1
		;;
esac

exit 1

