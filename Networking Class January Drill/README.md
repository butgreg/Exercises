
# Guided Exercise: Network Troubleshooting and Performance Monitoring

## Setup Overview
This lab environment consists of a simulated network with multiple subnets, VLANs, and devices. Key services include a router (BIRD), a DNS server (dnsmasq), a syslog server, Linux servers and clients, and traffic generators. Participants will use this setup to explore troubleshooting and performance monitoring.
**It is important to note** the corrections implemented in this environment are not "real-world" in nature and would not be the methods implemented in a production environment. The purpose of this lab is to familiarize participants with network troubleshooting concepts as a whole, not the particular implementations that are environment-specific.

The lab was developed in a RedHat Enterprise Linux environment and it became evident that certain features will not work with some kernels. Currently this lab runs best on Debian/Ubuntu environments.
---

### PreRequisites - building the lab and logging into linux_client1
- **Building the lab**: build the lab by downloading the entire project. Navigate to the main folder, and run the command `sudo docker compose up` to suppress the logging in the terminal, supply the `-d` option. give the lab 3-5 minutes to build as it will completely update a Kali image on the linux_client1 machine.
- **logging into linux_client1**: after sufficient time has passed and all machines have been built, check the lab's status by running `sudo docker ps` and when ready, SSH into the `linux_client1` machine using credentials: `user` : `practicalexercise` or use the command `sudo docker exec -it linux_client1 bash`
- **logging into other devices**: To simulate physically logging into a machine for troubleshooting (like the router) use the docker interactive terminal command `sudo docker exec -it >>device<<` and supply the shell to use (`sh` or `bash` for example)

## Part 1: Network Troubleshooting

### Exercise 1: Identifying and Resolving IP Conflicts
- **Scenario**: The unauthorized device on the LAN network causes an IP conflict. As a result, Network connectivity for some devices is intermittent, and users cannot reliably SSH into `linux_client1`. 
- **Task**: Use ARP commands and tools like `arping`, `tcpdump`, `iproute2` or `nmap` on `linux_client1` and `router` to identify conflicting IPs. Document the resolution steps and how to prevent such conflicts in the future.

---

### Exercise 2: Diagnosing DNS Resolution and Routing Issues
- **Scenario**: Devices in the `lan_network` cannot resolve the hostname of the `linux_server.lan` (192.168.20.5).
- **Task**: Use `nslookup` or `dig` on `linux_client1` to troubleshoot DNS resolution. Verify the configuration of the `dnsmasq` server and suggest corrections if necessary.

---

### Exercise 3: Locating and Addressing Packet Loss
- **Scenario**: `linux_client1` reports packet loss when communicating with `linux_client2`.
- **Task**: Use `ping` and `traceroute` to identify where the packet loss occurs. Examine the router's configuration (`bird.conf`) for potential misconfigurations affecting routing.

---

### Exercise 4: Tracing and Resolving Latency Spikes
- **Scenario**: Video traffic simulated by the `traffic_gen1` container experiences high latency.
- **Task**: Analyze traffic using `tcpdump` on `trafficgen1`. Propose and implement optimizations to reduce latency, such as verifying QoS or balancing load.


## Add syslog exercise


---
## REMOVE THIS SECTION
### Exercise 5: Debugging DHCP Allocation Problems
- **Scenario**: `linux_client2` fails to receive an IP address from the DHCP server.
- **Task**: Inspect the DHCP server (`dnsmasq.conf`) configuration and logs. Confirm the DHCP ranges and client requests, resolving any misconfigurations.

---

### Exercise 6: Investigating Routing Misconfigurations
- **Scenario**: Devices in `vlan1` and `lan_network` cannot communicate due to misconfigurations in `bird.conf`.
- **Task**: Use ping and traceroute to verify connectivity to 192.168.20.5. Identify the missing route in `bird.conf`.

---

## Part 2: Network Capacity and Performance Monitoring

### Exercise 1: Analyzing Bandwidth Usage per Device
- **Scenario**: Bandwidth usage spikes during peak hours due to traffic from `traffic_gen1`.
- **Task**: Use `iperf` to measure bandwidth consumption on `linux_server`. Identify top bandwidth consumers and recommend rate-limiting solutions.

---


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