#!/bin/sh

# Start Open vSwitch service
service openvswitch-switch start

# Create the OVS bridge
ovs-vsctl add-br br0

# Add interfaces for the networks
ovs-vsctl add-port br0 lan_port -- set interface lan_port type=internal
ovs-vsctl add-port br0 vlan1_port -- set interface vlan1_port type=internal
ovs-vsctl add-port br0 vlan2_port -- set interface vlan2_port type=internal

# Bring up the internal ports
ip link set dev lan_port up
ip link set dev vlan1_port up
ip link set dev vlan2_port up

# Assign IP addresses to the switch ports (if needed for testing/debugging)
ip addr add 192.168.10.2/24 dev lan_port
ip addr add 192.168.20.2/24 dev vlan1_port
ip addr add 192.168.30.2/24 dev vlan2_port

# Optional: Configure VLANs if needed
# ovs-vsctl set port vlan1_port tag=10
# ovs-vsctl set port vlan2_port tag=20

# Keep the container running
tail -f /dev/null
