
# Guided Exercise: Network Troubleshooting and Performance Monitoring

## Setup Overview
This lab environment consists of a simulated network with multiple subnets, VLANs, and devices. Key services include a router (BIRD), a DNS server (dnsmasq), a syslog server, Linux servers and clients, and traffic generators. Participants will use this setup to explore troubleshooting and performance monitoring.

The lab was developed in a RedHat Enterprise Linux environment and it became evident that certain features will not work with some kernels. currently this lab runs best on Debian/Ubuntu environments.
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



# Traffic Control (`tc`) Commands for Network Impairments

## **Commands to Introduce Impairments**

### 1. Introduce Latency
- Add a fixed delay to all packets on the `eth0` interface:
  ```bash
  tc qdisc add dev eth0 root netem delay 100ms
  ```
- Add variable latency (jitter) for more realism:
  ```bash
  tc qdisc add dev eth0 root netem delay 100ms 20ms distribution normal
  ```

---

### 2. Simulate Packet Loss
- Introduce a fixed percentage of packet loss:
  ```bash
  tc qdisc add dev eth0 root netem loss 10%
  ```
- Simulate bursty packet loss:
  ```bash
  tc qdisc add dev eth0 root netem loss 5% 25%
  ```

---

### 3. Simulate Network Congestion
- Limit bandwidth to 1Mbps:
  ```bash
  tc qdisc add dev eth0 root tbf rate 1mbit burst 32kbit latency 400ms
  ```

---

### 4. Simulate Packet Corruption
- Introduce random packet corruption:
  ```bash
  tc qdisc add dev eth0 root netem corrupt 1%
  ```

---

### 5. Simulate Reordering of Packets
- Reorder packets with a certain probability:
  ```bash
  tc qdisc add dev eth0 root netem delay 100ms reorder 25% 50%
  ```

---

### 6. Simulate Duplication of Packets
- Duplicate packets with a fixed probability:
  ```bash
  tc qdisc add dev eth0 root netem duplicate 2%
  ```

---

## **Commands to Remove Impairments**

### 1. Remove All Impairments
- Delete all traffic control rules on the `eth0` interface:
  ```bash
  tc qdisc del dev eth0 root
  ```

---

### 2. Modify an Existing Rule
- Change the impairment (e.g., adjust latency to 200ms):
  ```bash
  tc qdisc change dev eth0 root netem delay 200ms
  ```

---

### 3. List Current Configuration
- View the current `tc` settings for troubleshooting:
  ```bash
  tc qdisc show dev eth0
  ```

---

## **Examples in Practice**

### 1. Simulate a Congested Network with Latency and Packet Loss
```bash
tc qdisc add dev eth0 root handle 1: netem delay 100ms loss 5%
tc qdisc add dev eth0 parent 1:1 tbf rate 512kbit burst 32kbit latency 400ms
```

---

### 2. Reset the Interface to Default (No Impairments)
```bash
tc qdisc del dev eth0 root
```

---

These commands can be integrated into a lab environment via startup scripts or executed dynamically using `docker exec`.
```