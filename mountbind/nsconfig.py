#!/usr/bin/python

from pyroute2 import netns
import os
import re
import sys
import signal
from subprocess import check_output

def get_pid(name):
    return int(check_output(["pidof","-s",name]))

if (len(sys.argv) == 3):
	nsname = sys.argv[1]
	status = sys.argv[2]
else: 
	print ("Script usage: ./nsconfig.sh [NSname] [start/stop]")
	sys.exit(1)

lockfilename = nsname + ".lock"
sockfilename = nsname + ".sock"
pidfilename = nsname + ".pid"

if (status == "start"):
	file = open('/tmp/' + lockfilename, 'w+')
	file.close()
	file = open('/tmp/' + sockfilename, 'w+')
	file.close()
	file = open('/tmp/' + pidfilename, 'w+')
	file.close()

	bashcommand = "ip netns exec " + '"' + nsname + '"' + " mount --bind " + "/tmp/" + lockfilename + " /var/run/rpcbind.lock"
	os.system(bashcommand)
	bashcommand = "ip netns exec " + '"' + nsname + '"' + " mount --bind " + "/tmp/" + sockfilename + " /var/run/rpcbind.sock"
	os.system(bashcommand)
	bashcommand = "ip netns exec " + '"' + nsname + '"' + " rpcbind"
	os.system(bashcommand)
	pid = get_pid("rpcbind")
	f = open('/tmp/' + pidfilename, 'w+')
	f.write(str(pid))
	f.close()

elif (status == "stop"):
	f = open('/tmp/' + pidfilename, 'w+')
	pid = f.readline()
	os.kill(int(pid), signal.SIGKILL)
	bashcommand = "umount " + "/tmp/" + lockfilename
	os.system(bashcommand)
	bashcommand = "umount " + "/tmp/" + sockfilename
	os.system(sockfile)
	os.remove('/tmp/' + lockfilename)
	os.remove('/tmp/' + sockfilename)
	os.remove('/tmp/' + pidfilename)

else:
	print ("Script usage: ./nsconfig.sh [NSname] [start/stop]")
	sys.exit(1)



