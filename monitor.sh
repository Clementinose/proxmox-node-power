#!/bin/bash
# Proxmox Node Power Monitor – REAL data only

clear
echo "==============================="
echo "🔌 Proxmox Node Power Monitor"
echo "==============================="

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')

echo "🖥️ Hostname: $HOSTNAME"
echo "🌐 IP: $IP"

POWER_W=""

# 1️⃣ IPMI via DCMI (Dell / HP PowerEdge)
if command -v ipmitool >/dev/null 2>&1; then
    POWER_W=$(ipmitool dcmi power reading 2>/dev/null \
      | awk -F: '/Instantaneous power reading/ {gsub(/ W/,"",$2); print $2}')
fi

# 2️⃣ UPower (endast laptops / UPS)
if [ -z "$POWER_W" ] && command -v upower >/dev/null 2>&1; then
    DEV=$(upower -e | grep -Ei 'battery|ups' | head -n1)
    if [ -n "$DEV" ]; then
        POWER_W=$(upower -i "$DEV" | awk '/energy-rate/ {print int($2*1000)}')
    fi
fi

# 3️⃣ Output
if [ -z "$POWER_W" ]; then
    echo "⚡ Strömförbrukning: value cannot be found"
    echo "📅 Per månad: value cannot be found"
    echo "📅 Per år: value cannot be found"
else
    echo "⚡ Strömförbrukning: $POWER_W W"

    DAY_KWH=$(awk "BEGIN {print ($POWER_W*24)/1000}")
    MONTH_KWH=$(awk "BEGIN {print $DAY_KWH*30}")
    YEAR_KWH=$(awk "BEGIN {print $DAY_KWH*365}")

    echo "📅 Per dag:   ${DAY_KWH} kWh"
    echo "📅 Per månad: ${MONTH_KWH} kWh"
    echo "📅 Per år:    ${YEAR_KWH} kWh"
fi

echo "==============================="
