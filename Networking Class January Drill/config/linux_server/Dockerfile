FROM ubuntu:latest

# Install required tools and Apache
RUN apt-get update && apt-get install -y \
    iperf3 \
    tcpdump \
    netcat-traditional \
    apache2 \
    iproute2

# Configure Apache
RUN echo 'ServerName 192.168.20.5:80' >> /etc/apache2/apache2.conf
RUN echo '<h1>Welcome to Linux Server</h1>' > /var/www/html/index.html

# Expose the HTTP port
EXPOSE 80

# Start Apache and keep the container running
CMD ["apachectl", "-D", "FOREGROUND"]
