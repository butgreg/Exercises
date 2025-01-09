#!/bin/sh

# Wait for the interface to be ready
while ! ip link show eth0 > /dev/null 2>&1; do
    sleep 1
done

# Set the default route
ip route del default
ip route replace default via 192.168.10.1 dev eth0 metric 100


# Simulate network latency (100ms delay)
# tc qdisc add dev eth0 root netem delay 100ms

# Start iperf3 client loop
while true; do
    iperf3 -c 192.168.20.201
    sleep 5
done
tail -f /dev/null