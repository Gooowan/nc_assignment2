#!/bin/bash

if [ -z "$SOCAT_PEERADDR" ]; then
    echo "Error: SOCAT_PEERADDR is not set. This script should be run via socat." >&2
    exit 1
fi

echo "Enter the authorization key for IP ${SOCAT_PEERADDR}:"
read auth_key

CREDENTIALS_FILE="credentials.txt"

auth_key=$(echo "${auth_key}" | tr -d '\r\n' | xargs) 
SOCAT_PEERADDR=$(echo "${SOCAT_PEERADDR}" | tr -d '\r\n' | xargs)

if grep -q "^${SOCAT_PEERADDR} ${auth_key}$" "$CREDENTIALS_FILE"; then
    sudo iptables -D INPUT -p tcp -m tcp --dport 21 -j DROP

    if ! sudo iptables -C INPUT -p tcp -s "${SOCAT_PEERADDR}" --dport 21 -j ACCEPT 2>/dev/null; then
        echo "Adding iptables rule for IP: ${SOCAT_PEERADDR}" >&2
        sudo iptables -A INPUT -p tcp -s "${SOCAT_PEERADDR}" --dport 21 -j ACCEPT
    else
        echo "iptables rule for IP: ${SOCAT_PEERADDR} already exists. No duplicate added." >&2
    fi

    sudo iptables -A INPUT -p tcp -m tcp --dport 21 -j DROP
    echo "Authorization successful. iptables updated for IP: ${SOCAT_PEERADDR}" >&2
else
    echo "Authorization failed. No access granted for IP: ${SOCAT_PEERADDR}" >&2
    if sudo iptables -C INPUT -p tcp -s "${SOCAT_PEERADDR}" --dport 21 -j ACCEPT 2>/dev/null; then
        echo "Removing existing iptables rule for IP: ${SOCAT_PEERADDR}" >&2
        sudo iptables -D INPUT -p tcp -s "${SOCAT_PEERADDR}" --dport 21 -j ACCEPT
    else
        echo "No existing iptables rule to remove for IP: ${SOCAT_PEERADDR}" >&2
    fi
fi
