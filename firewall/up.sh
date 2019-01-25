#!/bin/bash

FW=/etc/firewall

QUIET=no
SYNLOG=no
TARPITLOG=no
FW_DRY_RUN=${DRY_RUN:=0}

# Print iptables if FW_DRY_RUN is set to 0
if [ "$FW_DRY_RUN" -eq "0" ]; then
        iptables="/sbin/iptables"
else
        iptables="echo iptables $@"
fi

# Verify auto-generated scripts exists else die
if [ ! -f $FW/generated/zones.sh ] || [ ! -f $FW/generated/policies.sh ]; then
	echo "zones.sh or policies.sh does not exist, run fwc as root and run up.sh again"
	exit 1;
fi


# Flush to known state (forwarding disabled)
. $FW/flush.sh

# Load configuration variables
. $FW/vars.sh

# Load protocol chains
. $FW/proto.sh

# Load tarpit system
#. $FW/tarpit.sh

# Load raw table rules
#. $FW/raw.sh

# Load address translation and spoof traps
. $FW/nat.sh

#. $FW/spoof.sh

echo "Run generated zones"
. $FW/generated/zones.sh


echo "Run generated policies"
. $FW/generated/policies.sh                                   

# Load logging policies
. $FW/policy.sh

# Enable forwarding/routing
#echo "1" > /proc/sys/net/ipv4/ip_forward

# Enable special routing
#. $FW/route.sh

echo "Firewall rules loaded"
