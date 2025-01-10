# Base image
FROM ubuntu:latest

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install syslog-ng and other required tools
RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    syslog-ng \
    syslog-ng-core \
    syslog-ng-mod-json \
    syslog-ng-mod-sql \
    bash && \
    apt-get clean

# Create the syslog user to avoid permission issues
RUN useradd -r -s /bin/false syslog

# Copy the startup script and syslog-ng.conf
COPY startup.sh /usr/local/bin/startup.sh
COPY syslog-ng.conf /config/syslog-ng.conf
COPY smart-multi-line.fsm /usr/share/syslog-ng/smart-multi-line.fsm

# Ensure the startup script is executable
RUN chmod +x /usr/local/bin/startup.sh

# Expose syslog ports
EXPOSE 514/udp 514/tcp

# Set the entrypoint to the startup script
ENTRYPOINT ["/usr/local/bin/startup.sh"]
