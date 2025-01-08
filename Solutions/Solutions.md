
# Guided Exercise: Network Troubleshooting and Performance Monitoring

## Solutions

---

## Part 1: Network Troubleshooting

### Exercise 1: Identifying and Resolving IP Conflicts
- **Scenario**: The unauthorized device on the LAN network causes an IP conflict. As a result, Network connectivity for some devices is intermittent, and users cannot reliably SSH into `linux_client1`. 
- **Task**: Use ARP commands and tools like `arping`, `tcpdump`, `iproute2` or `nmap` on `linux_client1` and `router` to identify conflicting IPs. Document the resolution steps and how to prevent such conflicts in the future.
**Solution**: Logging into `linux_client1` is unreliable due to the IP conflict. log in using `sudo docker exec -it linux_client1 bash` and perform troubleshooting. 
    - For devices with the same IP, incoming packets might be delivered to one or the other depending on the state of the ARP table on the sender. 
    - Change the ip address of linux_client1
    `  ip addr flush dev eth0`
    `ip a add 192.168.10.88/24 brd 192.168.10.255 dev eth0` 
    - ping the ip address to load the arp table.
    `ping 192.168.10.100`
    - output should be 
    `linux_client1.networkingclassjanuarydrill_lan_network (192.168.10.100) at 02:42:de:ad:be:ef [ether]  on eth1`
    - Make a note of this MAC address for later.
        #### Resolving Unauthorized Device IP Conflict

        ##### Steps to Resolve the IP Conflict

        ###### 1. **Identify the Unauthorized Device**
        - Use `arp` or `tcpdump` to find the MAC address of the device conflicting with `linux_client1`.
        ```bash
        arp -n | grep 192.168.10.100
        tcpdump -i eth0 arp
        ```
        - Match the MAC address with physical devices or the switch MAC address table.
        ```bash
        show mac address-table | include <MAC_ADDRESS>
        ```

        ###### 2. **Reconfigure the Unauthorized Device**
        - **Log In to the Device**:
        - Remove the conflicting IP.
            ```bash
            ip addr flush dev eth0
            ip addr add 192.168.10.<new_ip>/24 dev eth0
            ```
        - Enable DHCP if static IP is not required:
            ```bash
            dhclient eth0
            ```

        ###### 3. **Block the Unauthorized Device**
        - If reconfiguration is not possible:
        - Block the MAC address at the router:
            ```bash
            iptables -A INPUT -m mac --mac-source <MAC_ADDRESS> -j DROP
            iptables -A FORWARD -m mac --mac-source <MAC_ADDRESS> -j DROP
            ```
        - Physically disconnect the device.

        ###### 4. **Update Network Policies**
        - Reserve IPs using DHCP to avoid conflicts:
        ```
        host linux_client1 {
            hardware ethernet <MAC>;
            fixed-address 192.168.10.100;
        }
        ```
        - Define ranges for static and dynamic IPs:
        ```
        DHCP: 192.168.10.100-192.168.10.200
        Static: 192.168.10.10-192.168.10.99
        ```

        ###### 5. **Monitor the Network**
        - Install `arpwatch` to detect future conflicts:
        ```bash
        apt-get install arpwatch
        ```
        - Regularly scan the network with `nmap`:
        ```bash
        nmap -sP 192.168.10.0/24
        ```

        ###### 6. **Re-Verify the Network**
        - Confirm only one MAC is responding for `192.168.10.100`:
        ```bash
        arp -n
        ```
        - Ensure `linux_client1` operates without conflict.
        ```
