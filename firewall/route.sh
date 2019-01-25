#!/bin/bash

# Routing instructions for email:  route anything with 255 netfilter mark via gtux.sconet
# unless the routing is already set up

# 91.221.196.11 is qxfr.gratisdns.dk - the IP to notify when request for zonetransfer
if ! ip route show | fgrep -q 91.221.196.11; then
    ip route add 91.221.196.11 via 10.141.50.1 dev eth0:0 src 10.141.50.7
else
   [ $QUIET = yes ] || echo "Route to axfr.gratisdns.dk exists";
fi

