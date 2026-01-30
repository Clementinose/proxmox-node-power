#!/bin/bash
# Script för att visa strömförbrukning på den här noden

clear
echo "🔌 Proxmox Node Power Monitor"
echo "==============================="

# Visa hostname
HOSTNAME=$(hostname)
echo "🖥️ Hostname: $HOSTNAME"

# IP-adress
IP=$(hostname -I | awk '{print $1}')
echo "🌐 IP: $IP"

# Förbrukning (om du har IPMI/Redfish / UPS via upower)
# Här simulerar vi bara med random värde för demo
POWER_W=$(shuf -i 50-250 -n 1)
echo "⚡ Strömförbrukning: $POWER_W W"

echo "==============================="
