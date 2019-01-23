#!/bin/bash
for chain in "$@"; do
	sudo iptables -L $chain -v -n | column -t
done

