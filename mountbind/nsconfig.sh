#!/bin/bash

usage() {
    echo "Usage: $0 ns_name [start|stop]"
}

start() {
    ip link set lo up

    touch /tmp/$1.lock
    mount --bind /tmp/$1.lock /var/run/rpcbind.lock

    touch /tmp/$1.sock
    mount --bind /tmp/$1.sock /var/run/rpcbind.sock

    /sbin/rpcbind
}

stop() {
    # Find PID of process listening on TCP port 111 (sunrpc) in namespace $1
    pid=`lsof -bt -i4 -a -i TCP:sunrpc`

    if [ ! -z $pid ]; then
        kill -ABRT $pid
    fi

    # This does not work if another file was mounted on top
    # Probably we do not need to unmount / rm, only check
    # in the start() function if mount already exists
    umount /tmp/$1.lock
    umount /tmp/$1.sock

    rm /tmp/$1.lock
    rm /tmp/$1.sock
}

### script body ###

ns="$1"
op="$2"

if [ $# -lt 2 -o -z $ns ]; then
    usage
    exit 1
fi

case "$op" in
    "start")
        if [ ! -f /var/run/netns/$ns ]; then
            ip netns add "$ns"
        fi
        ip netns exec "$ns" $0 "$ns" start-in-ns
        ;;
    "stop")
        ip netns exec "$ns" $0 "$ns" stop-in-ns
        ip netns del "$ns"
        ;;
    "start-in-ns")
        start "$ns"
        ;;
    "stop-in-ns")
        stop "$ns"
        ;;
    *)
        usage
        exit 1
        ;;
esac
