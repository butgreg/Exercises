
# Guided Exercise: Network Troubleshooting and Performance Monitoring

## Solutions

---

## Part 1: Network Troubleshooting

### Exercise 1: Identifying and Resolving IP Conflicts
- **Scenario**: The unauthorized device on the LAN network causes an IP conflict. As a result, Network connectivity for some devices is intermittent, and users cannot reliably SSH into `linux_client1`. 
- **Task**: Use ARP commands and tools like `arping`, `tcpdump`, `iproute2` or `nmap` on `linux_client1` and `router` to identify conflicting IPs. Document the resolution steps and how to prevent such conflicts in the future.
- **Solution**: Logging into `linux_client1` is unreliable due to the IP conflict. log in using `sudo docker exec -it linux_client1 bash` and perform troubleshooting. 
For devices with the same IP, incoming packets might be delivered to one or the other depending on the state of the ARP table on the sender. 
Change the ip address of linux_client1
`ip addr flush dev eth0`
`ip a add 192.168.10.88/24 brd 192.168.10.255 dev eth0` 
ping the ip address to load the arp table.
`ping 192.168.10.100`
output should be 
`linux_client1.networkingclassjanuarydrill_lan_network (192.168.10.100) at 02:42:de:ad:be:ef [ether]  on eth1`
