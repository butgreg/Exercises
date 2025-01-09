FROM networkstatic/iperf3:latest

# Install necessary tools for traffic control
RUN apt-get update && apt-get install -y iproute2 iputils-ping iperf3

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Use the script as the entrypoint
ENTRYPOINT ["/usr/local/bin/startup.sh"]
