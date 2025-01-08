#!/bin/sh

# Set ip address
ip addr flush dev eth0
ip addr add 192.168.20.100/24 brd 192.168.10.255 dev eth0

# Set the default route
ip route del default

# this line is wrong it should be 192.168.20.1
ip route replace default via 192.168.10.1 dev eth0 metric 100 

# Start the SSH daemon in the foreground
/usr/sbin/sshd -D
