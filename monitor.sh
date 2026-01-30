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

# Förbrukning (simulerad för demo)
# Byt ut mot IPMI, Redfish eller UPS via upower för riktiga värden
POWER_W=$(shuf -i 50-250 -n 1)
echo "⚡ Aktuell strömförbrukning: $POWER_W W"

# Beräkna energiförbrukning per månad och år
HOURS_PER_DAY=24
DAYS_PER_MONTH=30
DAYS_PER_YEAR=365

MONTH_KWH=$(echo "scale=2; $POWER_W * $HOURS_PER_DAY * $DAYS_PER_MONTH / 1000" | bc)
YEAR_KWH=$(echo "scale=2; $POWER_W * $HOURS_PER_DAY * $DAYS_PER_YEAR / 1000" | bc)

echo "📅 Strömförbrukning per månad: $MONTH_KWH kWh"
echo "📅 Strömförbrukning per år:    $YEAR_KWH kWh"

echo "==============================="
