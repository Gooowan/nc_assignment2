
# Assignment 2: Network Configuration and FTP Server Setup

## Overview

This assignment is designed to provide practical experience with network configuration, scripting for automation, and working with FTP server installation and configuration. It involves setting up a container environment, automating the setup of network configurations and an FTP server, and implementing an allow/deny service for managing IP-based access control using iptables.

## Getting Started

### Prerequisites

- A clean Multipass container based on Ubuntu 22.04 image.
- Sudo privileges for executing scripts and installing packages.

### Installation and Setup

1. **Prepare the Multipass Container**:
    - Install Multipass if not already installed.
    - Launch a new Ubuntu 22.04 container:
    ```bash
    multipass launch ubuntu --name networking-assignment
    ```
    - Access the container:
    ```bash
    multipass shell networking-assignment
    ```

2. **Clone the Assignment Repository** (Assuming the repository URL is provided; adjust as necessary):
    ```bash
    git clone https://github.com/Gooowan/nc_assignment2
    cd nc_assignment2
    ```

3. **Run the Setup Script**:
    - This script will install necessary tools, configure iptables, and set up the FTP server.
    ```bash
    ./setup_node.sh 192.168.0.1,10.10.1.2,10.10.2.1
    ```
    - The script expects a comma-separated list of IP addresses to allow FTP access.

### Configuration Files and Scripts

- `setup_node.sh` or `setup_node.py`: Automates the setup of network tools, FTP server (vsftpd), and iptables rules.
- `update_iptables.sh` or `update_iptables.py`: Manages iptables to allow or deny FTP access based on authorization keys.
- `credentials.txt`: Contains sample credentials for testing with the update_iptables script.

## Detailed Script Descriptions

### setup_node.sh

- Installs `ifconfig`, `nmap`, `vsftpd`, and `socat`.
- Adds iptables rules to disable ping (ICMP) from any host and manage FTP server access.
- Adds a user `ftp_user` with predefined credentials.
- Creates sample files accessible via FTP.

### update_iptables.sh

- Uses `socat` to listen on TCP port 7777, executing the script for incoming connections.
- Prompts the user for an authorization key, verifies it against `credentials.txt`, and updates iptables accordingly.
- Ensures only authorized IPs can access the FTP server.

## Usage

### Managing FTP Access with update_iptables.sh / update_iptables.py

- Run the script with `socat` to listen for authorization requests:
    ```bash
    socat TCP-LISTEN:7777,fork EXEC:./update_iptables.sh
    ```
- From a client machine, connect to the server and provide the authorization key when prompted. The script will manage iptables rules based on the provided credentials.

## Conclusion

This documentation covers the setup and usage of the network configuration and FTP server setup assignment. It includes the steps to prepare the environment, run the setup scripts, and manage FTP access using iptables. For detailed information on the commands and configurations used in the scripts, refer to the script files themselves.
