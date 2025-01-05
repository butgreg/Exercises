# Troubleshooting Exercise Guide: Using linux_client1 as the Jump Station

## Objective
Diagnose and resolve network issues using `linux_client1` as the central workstation. This guide follows the OSI model and incorporates both Docker-specific and traditional methods.

---

## Setup Overview
- **Jump Station**: `linux_client1` (192.168.10.100).
- **Target Systems**: `linux_client2`, `dns_server`, `router`, `unauthorized_device`, and other network components.
- **Tools**: `ping`, `traceroute`, `tcpdump`, `nmap`, `dig`, `nslookup`, and `arp-scan`.

---

## Exercise Scenarios

### Scenario 1: Identifying and Resolving IP Conflicts
**Symptoms**:
- Intermittent connectivity.
- Duplicate IP warnings in logs.

**Steps**:
1. Scan the subnet for conflicts using `arp-scan`.
2. Inspect the ARP cache.
3. Identify and disconnect the unauthorized device in Docker or via traditional methods.

**Expected Output**:
- Conflicting IP and MAC addresses detected.

**Resolution**:
- Reassign conflicting IPs.

---

### Scenario 2: Diagnosing DNS Resolution Issues
**Symptoms**:
- Hostnames fail to resolve.

**Steps**:
1. Test DNS resolution using `nslookup` or `dig`.
2. Ping the DNS server to confirm connectivity.
3. Inspect `dnsmasq.conf` and add missing entries.

**Expected Output**:
- Correct DNS records resolve successfully.

**Resolution**:
- Restart the DNS server.

---

### Scenario 3: Locating and Addressing Packet Loss
**Symptoms**:
- High packet loss between `linux_client1` and `linux_client2`.

**Steps**:
1. Use `ping` to test connectivity.
2. Trace routes using `traceroute`.
3. Check the router's routing table.

**Expected Output**:
- Packet loss pinpointed to the router.

**Resolution**:
- Update routing configurations in `bird.conf`.

---

### Scenario 4: Debugging DHCP Allocation Problems
**Symptoms**:
- IP address not assigned to `linux_client2`.

**Steps**:
1. Request a DHCP lease using `dhclient`.
2. Verify the DHCP range in `dnsmasq.conf`.

**Expected Output**:
- DHCP offers fail due to insufficient range.

**Resolution**:
- Expand the DHCP range and restart the service.

---

### Scenario 5: Investigating VLAN Misconfigurations
**Symptoms**:
- Devices in different VLANs cannot communicate.

**Steps**:
1. Verify VLAN routing rules in `bird.conf`.
2. Use `tcpdump` to capture VLAN-tagged packets.

**Expected Output**:
- VLAN tags are misconfigured or missing.

**Resolution**:
- Correct VLAN configurations and reload the router.

---

### Scenario 6: Detecting Unauthorized Devices
**Symptoms**:
- Unexpected devices appear on the network.

**Steps**:
1. Scan for devices using `nmap`.
2. Identify the unauthorized device and block its IP.

**Expected Output**:
- Unauthorized device detected by its IP and MAC.

**Resolution**:
- Block the device using `iptables` or by disconnecting it.

---

### Scenario 7: Resolving Latency Spikes
**Symptoms**:
- High latency between `traffic_gen1` and `traffic_gen_server`.

**Steps**:
1. Capture traffic using `tcpdump`.
2. Analyze delays and bottlenecks.

**Expected Output**:
- Latency caused by congested links or misconfigurations.

**Resolution**:
- Adjust QoS or load balancing settings.

---

### Scenario 8: Verifying Internet Connectivity
**Symptoms**:
- External websites are unreachable.

**Steps**:
1. Test external connectivity using `ping`.
2. Verify NAT configuration on the router.

**Expected Output**:
- NAT rules missing or incorrect.

**Resolution**:
- Add NAT rules using `iptables` and restart the router.

---

## Deliverables
1. **Logs**: Document command outputs and observations for each task.
2. **Corrected Configurations**: Submit updated `bird.conf` and `dnsmasq.conf`.
3. **Network Diagram**: Provide a diagram of the fixed topology.

---

## Bonus Challenges
1. Introduce new issues, such as incorrect gateways, and troubleshoot.
2. Monitor traffic logs using `syslog` and `tcpdump`.
