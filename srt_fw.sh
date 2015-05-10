#!/bin/bash
# Prompts for domains and IPs to block for quickly generating firewall rules
# MIT License
# Opsdisk LLC | opsdisk.com 

#sudo apt-get install iptables-persistent -y
#sudo apt-get install ufw -y

deny_domain_list=target_domains.txt
deny_ip_list=target_ips.txt

read -p "Enter any target DNS domains..."
vim $deny_domain_list

read -p "Enter any target IP address..."
vim $deny_ip_list

# Allow inbound SSH
SSHPORT=$(cat /etc/ssh/sshd_config | grep Port | cut -f 2 -d ' ')

# Allow dnmap port
dnmapport=2000

#ufw enable

#ufw allow $SSHPORT/tcp
iptables -A INPUT -i eth0 -p tcp --dport $SSHPORT -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport $SSHPORT -m state --state ESTABLISHED -j ACCEPT

#ufw allow 2000/tcp
iptables -A INPUT -i eth0 -p tcp --dport $dnmapport -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport $dnmapport -m state --state ESTABLISHED -j ACCEPT

while read domain; do
    nslookup $domain | egrep -v "#53" | grep Address: | cut -f 2 -d " " >> $deny_ip_list
done < $deny_domain_list

while read IP; do
    #ufw deny out on eth0 to $IP
    iptables -A INPUT -i eth0 -s $IP -j DROP
done < $deny_ip_list

iptables-save > /etc/iptables/rules.v4

#ufw status verbose
sudo iptables -L -n -v --line-numbers
