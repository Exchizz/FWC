#!/bin/sh

# System variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin

if [ "$FW_DRY_RUN" -eq "1" ]; then
	echo "Not changing default policies"
	return
fi
# Get resources

#    modprobe ip_tables
#     modprobe ip_conntrack
#     modprobe ip_conntrack_ftp

# Start in a known state

for A in filter nat mangle raw; do
   iptables -t $A -F
   iptables -t $A -X
   iptables -t $A -Z
done

# Set basic policy
iptables -P INPUT   DROP
iptables -P OUTPUT  DROP 
iptables -P FORWARD DROP 
iptables -t raw -P PREROUTING  ACCEPT
iptables -t nat -P PREROUTING  ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
#     echo "1" > /proc/sys/net/ipv6/conf/all/disable_ipv6		# No IPv6
#     echo "1" > /proc/sys/net/ipv4/tcp_syncookies
#     echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_all
#     echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
#     echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
#     echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
#     echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
#     for interface in /proc/sys/net/ipv4/conf/*/rp_filter; do
#         echo "1" > ${interface}
#     done
#     echo "1" > /proc/sys/net/ipv4/conf/all/log_martians
#     echo "1" > /proc/sys/net/ipv4/ip_forward

# All loopback traffic is acceptable; everything else is dropped

iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo "Firewall status: flushed"
