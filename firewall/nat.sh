#!/bin/sh

#[ $QUIET = yes ] || echo "Install DNS ROUTING DNAT..."

#     iptables -t nat -A PREROUTING -p tcp -d $GTUX --dport 53 \
#        -j DNAT --to-destination $DNS3

#     iptables -t nat -A PREROUTING -p udp -s $GRATIS_DNS_AXFR -d $GTUX --dport 53 \
#        -j DNAT --to-destination $DNS3

#[ $QUIET = yes ] || echo "Install SMTP ROUTING DNAT..."
#
#     # SMTP requests to EURON0 are answered by smtp1 service
#     iptables -t nat -A PREROUTING -p tcp -d $EURON0 --dport 25 \
#	-j DNAT --to-destination $SMTPSVC
#
#[ $QUIET = yes ] || echo "Install SMTP(VPN) ROUTING DNAT..."
#
#     # SMTP requests to EURON0 are answered by smtp1 service
#     iptables -t nat -A PREROUTING -p tcp -d $EURON_VPN --dport 25 \
#	-j DNAT --to-destination $SMTPVPNSVC
#
#[ $QUIET = yes ] || echo "Install WWW(http) ROUTING DNAT..."
#
#     iptables -t nat -A PREROUTING -p tcp -d $EURON0 --dport 80 \
#        -j DNAT --to-destination $HTTPSVC
#
#[ $QUIET = yes ] || echo "Install WWW(https) ROUTING DNAT..."
#
#     iptables -t nat -A PREROUTING -p tcp -d $EURON0 --dport 443 \
#        -j DNAT --to-destination $HTTPSVC
#
#[ $QUIET = yes ] || echo "Install WWW(http) ROUTING DNAT..."
#
#     iptables -t nat -A PREROUTING -p tcp -d $EURON1 --dport 80 \
#        -j DNAT --to-destination $HTTP1SVC
#
#[ $QUIET = yes ] || echo "Install WWW(https) ROUTING DNAT..."
#
#     iptables -t nat -A PREROUTING -p tcp -d $EURON1 --dport 443 \
#        -j DNAT --to-destination $HTTP1SVC
#
#
#[ $QUIET = yes ] || echo "Install DNS ROUTING DNAT..."
#
#     # DNS requests to EURON0 are answered by axfr2 service
#     iptables -t nat -A PREROUTING -p tcp -d $EURON0 --dport 53 \
#	-j DNAT --to-destination $DNSSVC
#
#     # DNS requests to EURON0 are answered by dns2 service
#     iptables -t nat -A PREROUTING -p udp -d $EURON0 --dport 53 \
#	-j DNAT --to-destination $DNS2

#[ $QUIET = yes ] || echo "Install SSH ROUTING from euron1 to eth1 (rpicluster)"
#    # SSH nat to eth1(rpicluster)
#    iptables -t nat -A PREROUTING -p tcp -d $EURON1 --dport 22 -j DNAT --to-destination $RPICLUSTER	
#
#    # MASQUERADE traffic from rpimanager(eth1, 192.168.0.1/24/
#    iptables -t nat -A POSTROUTING -s 192.168.0.1/24 -o eth0  -j MASQUERADE


[ $QUIET = yes ] || echo "Install Nat www to management"
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $LOCALHTTP:80

[ $QUIET = yes ] || echo "Install NAT ssh to management"
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j DNAT --to-destination $LOCALSSH:22

# Firewall is LabVPN server (port 443/tcp)
[ $QUIET = yes ] || echo "Install NAT labVPN (port 443)"
sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -d $EXTERNAL_CLUSTER_IP -j DNAT --to-destination $LOCALLABVPN:443

# Firewall is NTP server
[ $QUIET = yes ] || echo "Install NAT NTP to local"
sudo iptables -t nat -A PREROUTING -p tcp --dport 123 -j DNAT --to-destination $LOCALNTP:123

