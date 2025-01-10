#!/bin/sh

# Wait for the interface to be ready
while ! ip link show eth0 > /dev/null 2>&1; do
    sleep 1
done

# Set the default route
ip route replace default via 192.168.10.1 dev eth0 metric 100

rsyslogd -n

# Start the iperf3 server
iperf3 -s
