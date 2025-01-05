#!/bin/sh

# Install necessary packages
apk add --no-cache bird iproute2

# Enable IP forwarding
echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1

# Start the BIRD routing daemon
echo "Starting BIRD routing daemon..."
bird -c /etc/bird/bird.conf -d

# Keep the container alive
tail -f /dev/null
