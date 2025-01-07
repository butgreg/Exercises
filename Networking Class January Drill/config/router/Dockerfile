FROM alpine:latest

# Install required tools (BIRD, iproute2, iptables)
RUN apk add --no-cache bird iproute2 iptables

# Enable IP forwarding and disable ICMP redirects
RUN echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf && \
    echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf && \
    echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf

# Copy configuration files
COPY ./bird.conf /etc/bird/bird.conf

# startup script for better flexibility
COPY ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Run the startup script at container startup
ENTRYPOINT ["/usr/local/bin/startup.sh"]
