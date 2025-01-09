#!/bin/sh

# Function to check if an interface exists
wait_for_interface() {
    local iface=$1
    while ! ip link show "$iface" > /dev/null 2>&1; do
        echo "Waiting for interface $iface to be ready..."
        sleep 1
    done
}

# Wait for eth0 to be ready
wait_for_interface eth0

# Apply traffic control rules
# echo "Applying traffic control rules..."
# tc qdisc add dev eth0 root netem delay 100ms loss 10%

# Apply sysctl settings
sysctl -p /etc/sysctl.conf

# Enable IP forwarding and NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth3 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT

# Start BIRD
bird -c /etc/bird/bird.conf -d

# Keep the container running
tail -f /dev/null
