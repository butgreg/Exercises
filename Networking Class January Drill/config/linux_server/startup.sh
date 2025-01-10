#!/bin/sh

# Set ip address
ip addr flush dev eth0
ip addr add 192.168.20.5/24 brd 192.168.20.255 dev eth0

# Set the default route
ip route del default
ip route add default via 192.168.20.1 dev eth0 metric 100


# Start rsyslogd
rsyslogd -n &


# Install and configure FTP server
apt-get update && apt-get install -y vsftpd
mkdir -p /srv/ftp/files
echo "anon_root=/srv/ftp" >> /etc/vsftpd.conf
echo "anonymous_enable=YES" >> /etc/vsftpd.conf

# Start vsftpd manually if systemctl is unavailable
/usr/sbin/vsftpd &

# Generate a large 2GB file
while true; do
    if [ ! -f /srv/ftp/files/largefile.dat ]; then
        echo "Creating a 2GB file for FTP..."
        dd if=/dev/zero of=/srv/ftp/files/largefile.dat bs=1M count=2048
    fi
    sleep 60
done