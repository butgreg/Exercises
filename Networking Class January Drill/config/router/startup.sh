#!/bin/sh

# Apply sysctl settings
sysctl -p /etc/sysctl.conf

# Start BIRD
bird -c /etc/bird/bird.conf -d

# Add traffic control rules (if needed)
tc qdisc add dev eth0 root netem delay 100ms loss 10%

# Keep the container running
tail -f /dev/null
