#!/bin/sh

# Wait for the interface to be ready
while ! ip link show eth0 > /dev/null 2>&1; do
    sleep 1
done

# Set the default route
ip route del default
ip route add default via 192.168.20.1/24 dev eth0 metric 100

rsyslogd -n &

# Install FTP client
apt-get update && apt-get install -y wget

# Download file in a loop
while true; do
    echo "Downloading largefile.dat from 192.168.20.5..."
    wget -O /dev/null ftp://192.168.20.5/files/largefile.dat /tmp/largefile.dat
done

tail -f /dev/null