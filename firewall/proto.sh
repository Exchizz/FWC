#!/bin/dash

# Port ranges
UNPRIV=1024:65535
HIPRIV=512:1023
LOPRIV=0:511

[ $QUIET = yes ] || echo "Individual service chains:"
[ $QUIET = yes ] || echo -n '    '

    # Openvpn(lab) PROTOCOL
    $iptables -N vpn-lab-c2s
    $iptables -N vpn-lab-s2c

        # VPN-lab connection client to server
        $iptables -A vpn-lab-c2s -p tcp --dport 443 --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT

        # VPN-lab responses server to client
        $iptables -A vpn-lab-s2c -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

        [ $QUIET = yes ] || echo -n " vpn-lab"


    # Nagios monitoring 
    $iptables -N nagios-c2s
    $iptables -N nagios-s2c

        # ssh connection client to server
        $iptables -A nagios-c2s -p tcp --dport 5666 --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
        $iptables -A nagios-c2s -p tcp --dport 5666 --sport $HIPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
        # ssh responses server to client
        $iptables -A nagios-s2c -p tcp --sport 5666 -m state --state ESTABLISHED -j ACCEPT

        [ $QUIET = yes ] || echo -n " nagios"



    # DHCP PROTOCOL
    $iptables -N dhcp-c2s
    $iptables -N dhcp-s2c

	# Client enquiry to server, may be from BCAST_SRC or to BCAST_DST
	$iptables -A dhcp-c2s -p udp --sport bootpc --dport bootps -j ACCEPT
	# Server response
	$iptables -A dhcp-s2c -p udp --sport bootps --dport bootpc -j ACCEPT

	[ $QUIET = yes ] || echo -n " dhcp"

    # SYSLOG UDP PROTOCOL
    $iptables -N syslog-c2s

	# Syslog client to server, no response expected
	$iptables -A syslog-c2s -p udp --sport syslog  --dport syslog -j ACCEPT
	$iptables -A syslog-c2s -p udp --sport $UNPRIV --dport syslog -j ACCEPT

    # SECURE SHELL PROTOCOL
    $iptables -N ssh-c2s
    $iptables -N ssh-s2c

	# ssh connection client to server
	$iptables -A ssh-c2s -p tcp --dport ssh --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
	$iptables -A ssh-c2s -p tcp --dport ssh --sport $HIPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
	# ssh responses server to client
	$iptables -A ssh-s2c -p tcp --sport ssh -m state --state ESTABLISHED -j ACCEPT

	[ $QUIET = yes ] || echo -n " ssh"

    # DNS PROTOCOL
    $iptables -N dns-c2s
    $iptables -N dns-s2c

	# DNS request client to server
	$iptables -A dns-c2s -p udp --dport domain --sport $UNPRIV -j ACCEPT
	$iptables -A dns-c2s -p tcp --dport domain --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
	# DNS response server to client
	$iptables -A dns-s2c -p udp --sport domain --dport $UNPRIV -m state --state ESTABLISHED -j ACCEPT
	$iptables -A dns-s2c -p tcp --sport domain --dport $UNPRIV -m state --state ESTABLISHED -j ACCEPT

	[ $QUIET = yes ] || echo -n " dns"

    # Default PROTOCOL
    $iptables -N all-c2s
    $iptables -N all-s2c

	# Allow all outgoing
	$iptables -A all-c2s -m state --state NEW,ESTABLISHED -j ACCEPT
	# Allow ESTABLISHED back
	$iptables -A all-s2c -m state --state ESTABLISHED -j ACCEPT

	[ $QUIET = yes ] || echo -n " all"


    # NTP PROTOCOL 
    $iptables -N ntp-c2s
    $iptables -N ntp-s2c

	# NTP request client to server
	$iptables -A ntp-c2s -p udp --dport ntp -j ACCEPT
	$iptables -A ntp-c2s -p tcp --dport ntp -m state --state NEW,ESTABLISHED -j ACCEPT
	# NTP response server to client
	$iptables -A ntp-s2c -p udp --sport ntp -m state --state ESTABLISHED -j ACCEPT
	$iptables -A ntp-s2c -p tcp --sport ntp -m state --state ESTABLISHED -j ACCEPT

	[ $QUIET = yes ] || echo -n " ntp"

    # FTP PROTOCOL, ACTIVE and PASSIVE  (N.B. non-ftp packets can pass the passive connection rules)
    $iptables -N ftp-c2s
    $iptables -N ftp-s2c

	# FTP control request client to server
	$iptables -A ftp-c2s -p tcp --dport ftp --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
	# FTP data response, client to server, active mode
	$iptables -A ftp-c2s -p tcp --dport ftp-data --sport $UNPRIV -m state --state ESTABLISHED -j ACCEPT
	# FTP data request, client to server, passive mode
	$iptables -A ftp-c2s -p tcp --sport $UNPRIV --dport $UNPRIV -m state --state ESTABLISHED,RELATED -j ACCEPT

	# FTP control response server to client
	$iptables -A ftp-s2c -p tcp --sport ftp --dport $UNPRIV -m state --state ESTABLISHED -j ACCEPT
	# FTP data request, server to client, active mode
	$iptables -A ftp-s2c -p tcp --sport ftp-data --dport $UNPRIV -m state --state ESTABLISHED,RELATED -j ACCEPT
	# FTP data request, client to server, passive mode
	$iptables -A ftp-s2c -p tcp --sport $UNPRIV --dport $UNPRIV -m state --state ESTABLISHED -j ACCEPT

	[ $QUIET = yes ] || echo -n " ftp"

    # PING, TRACEROUTE ETC.
    $iptables -N ping-c2s
    $iptables -N ping-s2c

	# PING/TRACEROUTE outgoing packet
	$iptables -A ping-c2s -p icmp --icmp-type echo-request  -j ACCEPT
	# PING/TRACEROUTE incoming packet
	$iptables -A ping-s2c -p icmp --icmp-type echo-reply    -j ACCEPT
#	$iptables -A ping-s2c -p icmp --icmp-type time-exceeded -j ACCEPT

	[ $QUIET = yes ] || echo -n " ping"

    # Permitted ICMP Packets
    $iptables -N icmp-ok

	$iptables -A icmp-ok -p icmp --icmp-type source-quench		-j ACCEPT
	$iptables -A icmp-ok -p icmp --icmp-type parameter-problem	-j ACCEPT
	$iptables -A icmp-ok -p icmp --icmp-type fragmentation-needed	-j ACCEPT
	$iptables -A icmp-ok -p icmp --icmp-type destination-unreachable -j ACCEPT
	$iptables -A icmp-ok -p icmp --icmp-type time-exceeded		-j ACCEPT

	[ $QUIET = yes ] || echo -n " icmp"

    [ $QUIET = yes ] || echo '.'
    [ $QUIET = yes ] || echo -n '    ';

    # STANDARD SIMPLE TCP PROTOCOLS
    for P in auth http https smtp telnet whois mysql \
	     imap imaps rsync; do
	
	$iptables -N $P-c2s
	$iptables -N $P-s2c

	# Protocol P request client to server on port P
	$iptables -A $P-c2s -p tcp --dport $P --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
	# Protocol P response server to client from port P
	$iptables -A $P-s2c -p tcp --sport $P --dport $UNPRIV -m state --state ESTABLISHED     -j ACCEPT
	[ $QUIET = yes ] || echo -n " $P"
    done

    [ $QUIET = yes ] || echo "."

    $iptables -N one-off-in
    $iptables -N one-off-out
