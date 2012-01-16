#!/bin/bash

# This script adds a user defined chain called LOGDROP. No references to the new chain are created.
# packets sent to this chain are logged to the syslog, then dropped

# check if we have permissions (are we root?)
# if not, print an error message and exit
if [ $EUID -ne 0 ]
then
	echo "You must be root to run this script" >&2
	exit 1
fi

# Ensure an empty chain named LOGDROP exists
iptables -N LOGDROP
iptables -F LOGDROP

iptables -A LOGDROP -j LOG --log-prefix "Dropped Packet" --log-level 6
iptables -A LOGDROP -j DROP
