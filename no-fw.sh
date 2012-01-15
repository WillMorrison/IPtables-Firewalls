#!/bin/bash

# This script will remove all IPtables rules and set the default target for all chains to ACCEPT
# This is not a firewall, provides no security, and should probably only be used during testing.

# check if we have permissions (are we root?)
# if not, print an error message and exit
if [ $EUID -ne 0 ]
then
	echo "You must be root to run this script" >&2
	exit 1
fi

# Warn the user that they are about to mess with their firewall rules, and allow them to abort
echo "Warning: This script will replace all current IPtables rules."
echo -n "Really do this? [y/N] "
read -e

# determine the reply and exit if needed
if [ $? -eq 0 ]
then
	case "$REPLY" in
	"y"|"Y")
		echo "Applying new firewall rules"
		;;
	*)
		echo "Cancelled"
		exit 0
		;;
	esac
else
	echo "Cancelled"
	exit 0
fi

# set the default target to drop for all builtin chains
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Flush all currently active IPtables rules in all chains
iptables -F

