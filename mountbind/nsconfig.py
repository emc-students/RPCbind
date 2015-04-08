#!/usr/bin/python

from pyroute2 import netns
import os
import re
import sys


#if os.geteuid() != 0:
#    print "This script must be run as root\nBye"
#    exit(1)


if (len(sys.argv) == 2) :
	nsname = sys.argv[1]
else: 
	print ("Please, check your input. Correct using is nsconfig.py NSname")
	sys.exit(1)


print(netns.listnetns())

netnslist = os.listdir('/var/run/netns')
flag = 0
for netn in netnslist:
	if(nsname == netn):
		flag = 1
#Adding namespase + NSname.lock file
if(flag == 0):
	netns.create(nsname)

print(netns.listnetns())
lockfilename = nsname + ".lock"
file = open(lockfilename, 'w+')

bashcommand = "ip netns exec " + nsname + " mount --bind " + lockfilename + " /var/run/rpcbind.lock"
os.system(bashcommand)
bashcommand = "ip netns exec " + nsname + " rpcbind"
os.system(bashcommand)

