#!/bin/bash

IFS=',' read -r -a allowed_ips <<< "$1"

sudo apt-get update
sudo apt-get install -y nmap vsftpd socat net-tools

sudo adduser ftp_user --disabled-password --gecos ""
echo "ftp_user:MyFTPPass!" | sudo chpasswd

echo "Hello World!" | sudo tee /home/ftp_user/1.txt > /dev/null
echo "Hello World!" | sudo tee /home/ftp_user/2.txt > /dev/null

sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
for ip in "${allowed_ips[@]}"; do
    sudo iptables -A INPUT -p tcp -s "$ip" --dport 21 -j ACCEPT
done

sudo iptables -A INPUT -p tcp --dport 21 -j DROP

