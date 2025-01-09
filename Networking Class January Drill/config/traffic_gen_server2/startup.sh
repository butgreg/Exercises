#!/bin/sh

# Wait for the interface to be ready
while ! ip link show eth0 > /dev/null 2>&1; do
    sleep 1
done

# Set the default route
ip route replace default via 192.168.20.1 dev eth0 metric 100

# Install necessary tools
apt-get update && apt-get install -y iproute2 iputils-ping iperf3 tcpdump tshark

# Start the iperf3 server
iperf3 -s
