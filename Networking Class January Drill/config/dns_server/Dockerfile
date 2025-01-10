# Base image
FROM andyshinn/dnsmasq

# Add necessary capabilities for network management
RUN apk add --no-cache iproute2
RUN apk add --no-cache rsyslog

# Copy the dnsmasq configuration file into the container
COPY dnsmasq.conf /etc/dnsmasq.conf

# Copy the startup script into the container
COPY startup.sh /usr/local/bin/startup.sh

# Ensure the startup script is executable
RUN chmod +x /usr/local/bin/startup.sh

# Configure rsyslog to forward logs to the syslog server
RUN echo '*.* @192.168.20.250:514' >> /etc/rsyslog.conf


# Set the entrypoint to the startup script
ENTRYPOINT ["/usr/local/bin/startup.sh"]

# Default restart policy handled by Docker Compose
