# Facilitator Troubleshooting Guide for Docker Environment

## General Docker Commands
- **List running containers**:
  ```bash
  docker ps
  ```
- **Inspect a container's details**:
  ```bash
  docker inspect <container_name>
  ```
- **Access a container's shell**:
  ```bash
  docker exec -it <container_name> bash
  ```
- **View container logs**:
  ```bash
  docker logs <container_name>
  ```
- **Restart a container**:
  ```bash
  docker restart <container_name>
  ```

---

## Network Troubleshooting

### Verify Network Connectivity
- **List Docker networks**:
  ```bash
  docker network ls
  ```
- **Inspect a specific network**:
  ```bash
  docker network inspect <network_name>
  ```
- **Ping a container from another**:
  ```bash
  docker exec -it <source_container> ping <destination_ip>
  ```

### Resolve IP Conflicts
- **Scan for devices in a subnet**:
  ```bash
  docker exec -it linux_client1 arp-scan --interface=eth0 192.168.10.0/24
  ```
- **Check ARP cache**:
  ```bash
  docker exec -it linux_client1 arp -a
  ```

---

## DNS Troubleshooting

### Verify DNS Server Configuration
- **Check `dnsmasq.conf`**:
  ```bash
  docker exec -it dns_server cat /etc/dnsmasq.conf
  ```
- **Test DNS resolution**:
  ```bash
  docker exec -it linux_client1 nslookup linux_server
  ```
- **Ping the DNS server**:
  ```bash
  docker exec -it linux_client1 ping 192.168.10.2
  ```

---

## DHCP Troubleshooting

### Check DHCP Allocations
- **Request a DHCP lease manually**:
  ```bash
  docker exec -it linux_client2 dhclient -v eth0
  ```
- **Check `dnsmasq.conf` for DHCP range**:
  ```bash
  docker exec -it dns_server cat /etc/dnsmasq.conf
  ```
- **Restart DHCP server**:
  ```bash
  docker restart dns_server
  ```

---

## Routing and VLAN Troubleshooting

### Verify Router Configuration
- **Inspect BIRD configuration**:
  ```bash
  docker exec -it router cat /etc/bird/bird.conf
  ```
- **Check routing table**:
  ```bash
  docker exec -it router birdc show route
  ```
- **Reload BIRD**:
  ```bash
  docker exec -it router birdc configure
  ```

### Trace Routes
- **Traceroute to identify packet flow**:
  ```bash
  docker exec -it linux_client1 traceroute 192.168.20.100
  ```

---

## Packet Inspection

### Use `tcpdump`
- **Capture packets on a specific interface**:
  ```bash
  docker exec -it router tcpdump -i eth0
  ```
- **Filter traffic by IP**:
  ```bash
  docker exec -it router tcpdump -i eth0 host 192.168.10.100
  ```

---

## Monitoring Containers

### Check Resource Usage
- **View CPU and memory stats**:
  ```bash
  docker stats
  ```

### Check Logs
- **Retrieve logs for debugging**:
  ```bash
  docker logs <container_name>
  ```

---

## Simulating and Resolving Common Issues

### Simulate Unauthorized Device
- **Add an unauthorized container**:
  ```bash
  docker run -d --name unauthorized_device --network lan_network alpine sleep infinity
  ```
- **Block unauthorized device traffic**:
  ```bash
  docker exec -it router iptables -A INPUT -s <unauthorized_ip> -j DROP
  ```

### Resolve Connectivity Issues
- **Check if a container is connected to the right network**:
  ```bash
  docker network inspect lan_network | grep <container_name>
  ```
- **Reconnect a container to a network**:
  ```bash
  docker network connect lan_network <container_name>
  ```

---

## Facilitator Tips
1. Use `linux_client1` as the primary diagnostic tool for all network and application issues.
2. Save logs and output for future analysis.
3. Verify configurations in `bird.conf` and `dnsmasq.conf` regularly to avoid misconfigurations.
```