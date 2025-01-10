#!/bin/sh

# Set ip address
ip addr flush dev eth0
ip addr add 192.168.20.5/24 brd 192.168.20.255 dev eth0

# Set the default route
ip route del default
ip route add default via 192.168.20.1 dev eth0 metric 100

rsyslogd -n
