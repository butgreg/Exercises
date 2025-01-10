#!/bin/bash

# Ensure the configuration directory exists
if [ ! -d "/config/syslog-ng" ]; then
  echo "Creating configuration directory at /config/syslog-ng..."
  mkdir -p "/config/syslog-ng"
fi

# Ensure the logs directory exists
if [ ! -d "/logs" ]; then
  echo "Creating logs directory at /logs..."
  mkdir -p "/logs"
fi

# Check for syslog-ng.conf; create a default if missing
if [ ! -f "/config/syslog-ng/syslog-ng.conf" ]; then
  echo "Creating default syslog-ng.conf in /config/syslog-ng..."
  cat > "/config/syslog-ng/syslog-ng.conf" <<EOL
@version: 3.35
@include "scl.conf"

options {
    time-reap(30);
    mark-freq(3600);
    keep-hostname(yes);
};

source s_network {
    udp(port(514));
    tcp(port(514));
};

destination d_logs {
    file("/logs/syslog.log");
};

log {
    source(s_network);
    destination(d_logs);
};
EOL
fi

# Ensure appropriate permissions for configuration and logs
echo "Setting permissions for /config/syslog-ng and /logs..."
chown -R syslog:syslog "/config/syslog-ng" "/logs"
chmod -R 755 "/config/syslog-ng" "/logs"

# Ensure required directories exist
mkdir -p /run /var/run
chmod 755 /run /var/run

# Start syslog-ng in the foreground
syslog-ng -F --no-caps -f /config/syslog-ng.conf

echo "Successfully started"
