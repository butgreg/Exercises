# Base image
FROM kalilinux/kali-rolling

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required tools
RUN apt-get update && apt-get full-upgrade -y && apt-get install -y \
    inetutils-ping sudo iproute2 netcat-traditional apt-utils \
    tcpdump nmap dnsutils traceroute wireshark tshark iperf3 net-tools \
    arp-scan openssh-server

# Create a user with sudo privileges
RUN useradd -m -s /bin/bash user && \
    echo 'user:practicalexercise' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Prepare SSH server
RUN mkdir -p /run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Expose SSH port 
EXPOSE 22

# Copy the startup script into the container
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Use the startup script as the container's entry point
CMD ["/usr/local/bin/startup.sh"]
