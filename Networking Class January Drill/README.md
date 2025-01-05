
# Guided Exercise: Network Troubleshooting and Performance Monitoring

## Setup Overview
This lab environment consists of a simulated network with multiple subnets, VLANs, and devices. Key services include a router (BIRD), a DNS server (dnsmasq), a syslog server, Linux servers and clients, and traffic generators. Participants will use this setup to explore troubleshooting and performance monitoring.

---

## Part 1: Network Troubleshooting

### Exercise 1: Identifying and Resolving IP Conflicts
- **Scenario**: The unauthorized device on the LAN network causes an IP conflict. Network connectivity for some devices is intermittent.
- **Task**: Use ARP commands and tools like `iproute2` or `nmap` on `linux_client1` to identify conflicting IPs. Document the resolution steps and how to prevent such conflicts in the future.

---

### Exercise 2: Diagnosing DNS Resolution Issues
- **Scenario**: Devices in the `lan_network` cannot resolve the hostname of the `linux_server` (192.168.10.5).
- **Task**: Use `nslookup` or `dig` on `linux_client1` to troubleshoot DNS resolution. Verify the configuration of the `dnsmasq` server and suggest corrections if necessary.

---

### Exercise 3: Locating and Addressing Packet Loss
- **Scenario**: `linux_client1` reports packet loss when communicating with `linux_client2`.
- **Task**: Use `ping` and `traceroute` to identify where the packet loss occurs. Examine the router's configuration (`bird.conf`) for potential misconfigurations affecting routing.

---

### Exercise 4: Tracing and Resolving Latency Spikes
- **Scenario**: Video traffic simulated by the `traffic_gen1` container experiences high latency.
- **Task**: Analyze traffic using `tcpdump` on `linux_server`. Propose and implement optimizations to reduce latency, such as verifying QoS or balancing load.

---

### Exercise 5: Debugging DHCP Allocation Problems
- **Scenario**: `linux_client2` fails to receive an IP address from the DHCP server.
- **Task**: Inspect the DHCP server (`dnsmasq.conf`) configuration and logs. Confirm the DHCP ranges and client requests, resolving any misconfigurations.

---

### Exercise 6: Investigating VLAN Misconfigurations
- **Scenario**: Devices in `vlan1` and `lan_network` cannot communicate despite proper routing in `bird.conf`.
- **Task**: Examine VLAN configurations on the router and ensure appropriate tagging. Use Wireshark to verify traffic is routed correctly.

---

## Part 2: Network Capacity and Performance Monitoring

### Exercise 1: Analyzing Bandwidth Usage per Device
- **Scenario**: Bandwidth usage spikes during peak hours due to traffic from `traffic_gen1`.
- **Task**: Use `iperf` to measure bandwidth consumption on `linux_server`. Identify top bandwidth consumers and recommend rate-limiting solutions.

---

### Exercise 2: Identifying Traffic Bottlenecks
- **Scenario**: Wireless clients connected to `vlan1` report slow connections, while wired clients in `lan_network` function normally.
- **Task**: Use Wi-Fi Analyzer to assess wireless interference and iperf on wired connections to locate bottlenecks. Propose solutions such as additional access points or frequency adjustments.

---

## Deliverables
1. Document findings for each exercise, including identified issues, tools used, and resolution steps.
2. Submit network diagrams showing updated configurations post-troubleshooting.
3. Provide performance metrics for bandwidth and latency before and after optimization.
