FROM ubuntu:latest

# Install required tools and Apache
RUN apt-get update && apt-get full-upgrade -y && apt-get install -y \
    inetutils-ping iperf3 tcpdump \
    netcat-traditional \
    apache2 \
    iproute2


# Configure Apache
RUN echo 'ServerName 192.168.20.5:80' >> /etc/apache2/apache2.conf
RUN echo '<h1>Welcome to Linux Server</h1>' > /var/www/html/index.html

# Expose the HTTP port
EXPOSE 80


# Copy the startup script into the container
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh


# Install rsyslog
RUN apt-get update && apt-get install -y rsyslog

# Configure rsyslog to forward logs to the syslog server
RUN echo '*.* @192.168.20.250:514' >> /etc/rsyslog.conf

# Use the startup script as the container's entry point
# Use the startup script and start Apache to keep the container running

CMD ["/bin/bash", "-c", "/usr/local/bin/startup.sh && apachectl -D FOREGROUND"]
