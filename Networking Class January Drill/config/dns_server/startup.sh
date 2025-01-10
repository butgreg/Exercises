#!/bin/sh

# Add the default route
ip route add default via 192.168.10.1 dev eth0

rsyslogd -n

# Start dnsmasq
dnsmasq --conf-file=/etc/dnsmasq.conf --no-daemon
