
# Guided Exercise: Network Troubleshooting and Performance Monitoring

## Solutions

---

## Part 1: Network Troubleshooting

        ---

### Exercise 1: Identifying and Resolving IP Conflicts
- **Scenario**: The unauthorized device on the LAN network causes an IP conflict. As a result, Network connectivity for some devices is intermittent, and users cannot reliably SSH into `linux_client1`. 
- **Task**: Use ARP commands and tools like `arping`, `tcpdump`, `iproute2` or `nmap` on `linux_client1` and `router` to identify conflicting IPs. Document the resolution steps and how to prevent such conflicts in the future.
**Solution**: Logging into `linux_client1` is unreliable due to the IP conflict. log in using `sudo docker exec -it linux_client1 bash` and perform troubleshooting. 
    - For devices with the same IP, incoming packets might be delivered to one or the other depending on the state of the ARP table on the sender. so trying to discover what device is causing the conflict from a device experiencing a conflict is not effective.
    - Change the ip address of linux_client1
    `ip addr flush dev eth0`
    `ip a add 192.168.10.88/24 brd 192.168.10.255 dev eth0` 
    - ping the ip address to load the arp table.
    `ping 192.168.10.100` - this should succeed
    `arp -a`- output should be `linux_client1.networkingclassjanuarydrill_lan_network (192.168.10.100) at 02:42:de:ad:be:ef [ether]  on eth1`
    - Make a note of this MAC address for later.
#### Resolving Unauthorized Device IP Conflict
###### Option 1. **Reconfigure the Unauthorized Device**
**Log In to the Device**:
- Remove the conflicting IP.
```bash
ip addr flush dev eth0
ip addr add 192.168.10.<new_ip>/24 dev eth0
```
- Enable DHCP if static IP is not required:
```bash
dhclient eth0
```

###### 2. **Block the Unauthorized Device**
**If reconfiguration is not possible:**
- Block the MAC address at the router:
```bash
iptables -A INPUT -m mac --mac-source 02:42:de:ad:be:ef -j DROP
iptables -A FORWARD -m mac --mac-source 02:42:de:ad:be:ef -j DROP
```
- Physically disconnect the device.


### Exercise 2: Diagnosing DNS Resolution and Routing Issues
- **Scenario**: Devices in the `lan_network` cannot resolve the hostname of the `linux_server.lan` (192.168.20.5).
- **Task**: Use `nslookup` or `dig` on `linux_client1` to troubleshoot DNS resolution. Verify the configuration of the `dnsmasq` server and suggest corrections if necessary.
- **Solution**: The first replication of the problem is to log onto `linux_client1` and attempt to navigate to hostname `linux_server.lan` where it becomes evident that this does not resolve as intended. 
        - `nslookup linux_server.lan` shows that the default configuration of 127.0.0.1 is still configured. this needs to be changed to 192.168.10.53 as indicated on the network map
        - `nslookup linux_server.lan` now resolves the IP address from the dns server as 192.168.10.5 which is not what the network map says it should be.
        - Pinging 192.168.10.5 results in 100% packet loss, pinging 192.168.20.5 is successful
        - Log into `dns_server` using `sudo docker exec -it dns_server sh`
        - This server uses dnsmasq to conduct dns services for the network. Perform `cat /etc/dnsmasq.conf` and notice the misconfigured entry "address=/linux_server.lan/192.168.10.5  # Incorrect IP address"
        - to correct this use `vi /etc/dnsmasq.conf` and correct the ip address for `linux_server.lan` to 192.168.20.5.
        - save and quit out of the dnsmasq.conf file and restart the dnsmasq process. Because this server is minimally configured and does not have systemd , just kill the process using `pkill dnsmasq` and restart it using `dnsmasq --conf-file=/etc/dnsmasq.conf` ignore the "dnsmasq: failed to bind DHCP server socket: Address in use" message
        - `wget linux_server.lan` now properly resolves. 
        - If we wanted, we could populate entries for the rest of the devices so that DNS is configured for more than just `linux_server.lan`

        ---

### Exercise 3: Locating and Addressing Packet Loss
- **Scenario**: `linux_client1` reports packet loss when communicating with `linux_client2`.
- **Task**: Use `ping` and `traceroute` to identify where the packet loss occurs. Examine the router's configuration (`bird.conf`) for potential misconfigurations affecting routing.
- **Solution**: linux_client2 is nearly identical to `linux_client1`, so this should be straightforward. since we have mostly corrected misconfigurations on `linux_client1` we begin by logging into `linux_client2` using docker `sudo docker exec -it linux_client2 bash`.
        - On `linux_client2`, immediately pinging 192.168.10.100 results in the response "ping: sending packet: Network is unreachable" so we know this is a routing issue.
        - `ip route show` reveals that, similar to `linux_client1`, there is no default route. when attempting to add the route using `ip route del 192.168.20.0/24 dev eth0 proto kernel scope link src 192.168.20.100 && ip route add default via 192.168.20.1 dev eth0` we receive "Error: Nexthop has invalid gateway." as a response. 
        - `ip addr` reveals "inet 192.168.20.100/24 brd ***192.168.10.255*** scope global eth0" which indicates a misconfiguration of our broadcast domain for `linux_client2` even pinging our own gateway 192.168.20.1 would not work right now. This is the reason for the Nexthop has invalid gateway. 
        - This bad configuration needs to be replaced. Issue the commands `ip addr del 192.168.20.100/24 dev eth0` followed by `ip addr add 192.168.20.100/24 brd 192.168.20.255 dev eth0` and we should now be able to ping our gateway.
        - re-attempt `ip route add default via 192.168.20.1 dev eth0` and it should succeed. `linux_client1` and `linux_client2` are now able to ping eachother.
        ---

