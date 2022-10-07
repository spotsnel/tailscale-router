#!/bin/sh
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-routes=$(grep fly-local-6pn /etc/hosts | cut -f 1 | cut -d':' -f -3 | awk '{print $1"::/48"}')

/app/linux-amd64/dnsproxy -u fdaa::3

tail -f /dev/null
