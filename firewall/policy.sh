#!/bin/sh

[ $QUIET = yes ] || echo "Catch anything else on the INPUT/OUTPUT/FORWARD chains..."

$iptables -A INPUT   -j LOG --log-prefix "FW?L firewall Gate In: "  --log-level warning
$iptables -A OUTPUT  -j LOG --log-prefix "FW?L firewall Gate Out: " --log-level warning
$iptables -A FORWARD -j LOG --log-prefix "FW?L firewall Gate Fwd: " --log-level warning
