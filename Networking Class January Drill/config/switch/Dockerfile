# Base image
FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    openvswitch-switch iproute2 iputils-ping net-tools && \
    apt-get clean

# Create directories for configuration
RUN mkdir -p /etc/openvswitch

# Copy startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose ports for management (optional)
EXPOSE 6640 6653

# Entry point
CMD ["/usr/local/bin/startup.sh"]
