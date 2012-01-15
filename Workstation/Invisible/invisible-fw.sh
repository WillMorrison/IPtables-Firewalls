#!/bin/bash

# This script is designed to drop all IP-based network traffic, with the exception of traffic on the loopback device.

# the default name for the loopback device, change it if yours is named differently
LOOPBACK_DEV='lo'


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
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Flush all currently active IPtables rules in all chains
iptables -F

# add rules to accept loopback device traffic in the INPUT and OUTPUT chains
iptables -A INPUT -i "$LOOPBACK_DEV" -j ACCEPT
iptables -A OUTPUT -o "$LOOPBACK_DEV" -j ACCEPT

