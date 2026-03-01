#!/bin/bash
# DuckDNS dynamic DNS update script
# Updates your DuckDNS subdomain with your current public IP
# Add to crontab: */5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1

echo url="https://www.duckdns.org/update?domains=yourdomain&token=your-duckdns-token&ip=" | curl -k -o ~/duckdns/duck.log -K -
