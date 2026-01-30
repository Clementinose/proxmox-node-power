#!/bin/bash
# Script för att visa faktisk strömförbrukning på noden (inga simuleringar)

clear
echo "🔌 Proxmox Node Power Monitor"
echo "==============================="

# Hostname & IP
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
echo "🖥️ Hostname: $HOSTNAME"
echo "🌐 IP: $IP"

# Init
POWER_W=""

# 1️⃣ Försök IPMI (Dell/HP)
if command -v ipmitool &>/dev/null; then
    POWER_W=$(ipmitool sdr | grep -i "Watts" | awk '{print $2}' | head -n1)
fi

# 2️⃣ Försök Redfish (Dell/HugBox)
if [ -z "$POWER_W" ] && command -v curl &>/dev/null; then
    # Redfish endpoint måste konfigureras per maskin, exempel:
    # POWER_W=$(curl -s -k -u "USER:PASS" https://$IP/redfish/v1/Chassis/1/Power | jq '.PowerControl[0].PowerConsumedWatts')
    POWER_W="" # placeholder, kräver Redfish credentials
fi

# 3️⃣ Försök UPower (batteri/UPS)
if [ -z "$POWER_W" ] && command -v upower &>/dev/null; then
    BATTERY=$(upower -e | grep -i 'battery' | head -n1)
    if [ ! -z "$BATTERY" ]; then
        POWER_W=$(upower -i $BATTERY | grep -E "power" | awk '{print int($2)}')
    fi
fi

# 4️⃣ Om inget funkar
if [ -z "$POWER_W" ]; then
    POWER_W="Value cannot be found"
fi

echo "⚡ Aktuell strömförbrukning: $POWER_W W"

# Beräkna kWh om vi har ett värde
if [[ "$POWER_W" != "Value cannot be found" ]]; then
    HOURS_PER_DAY=24
    DAYS_PER_MONTH=30
    DAYS_PER_YEAR=365

    MONTH_KWH=$(echo "scale=2; $POWER_W * $HOURS_PER_DAY * $DAYS_PER_MONTH / 1000" | bc)
    YEAR_KWH=$(echo "scale=2; $POWER_W * $HOURS_PER_DAY * $DAYS_PER_YEAR / 1000" | bc)

    echo "📅 Strömförbrukning per månad: $MONTH_KWH kWh"
    echo "📅 Strömförbrukning per år:    $YEAR_KWH kWh"
else
    echo "📅 Strömförbrukning per månad: Value cannot be found"
    echo "📅 Strömförbrukning per år:    Value cannot be found"
fi

echo "==============================="
