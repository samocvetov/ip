#!/usr/bin/env bash

TIMEOUT=4

get_ipv4() {
    curl -4 -s --max-time $TIMEOUT https://api.ipify.org
}

get_ipv6() {
    curl -6 -s --max-time $TIMEOUT https://api64.ipify.org
}

get_country() {
    curl -s --max-time $TIMEOUT ipinfo.io/$1/country 2>/dev/null
}

get_asn() {
    curl -s --max-time $TIMEOUT ipinfo.io/$1/org 2>/dev/null
}

dns_country() {
    HOST=$1
    TYPE=$2

    if [ "$TYPE" = "4" ]; then
        IP=$(dig +short A $HOST | head -n1)
    else
        IP=$(dig +short AAAA $HOST | head -n1)
    fi

    [ -z "$IP" ] && echo "N/A" && return
    get_country $IP
}

echo

IP4=$(get_ipv4)
IP6=$(get_ipv6)

C4=$(get_country $IP4)
C6=$(get_country $IP6)
ASN=$(get_asn $IP4)

echo "IPv4: ${IP4:-N/A}, registered in ${C4:-N/A}"
echo "IPv6: ${IP6:-N/A}, registered in ${C6:-N/A}"
echo "ASN: ${ASN:-N/A}"
echo
echo "Popular services"
echo
printf "%-20s %-6s %-6s\n" "Service" "IPv4" "IPv6"

printf "%-20s %-6s %-6s\n" \
"Google" \
"$(dns_country www.google.com 4)" \
"$(dns_country www.google.com 6)"

printf "%-20s %-6s %-6s\n" \
"YouTube" \
"$(dns_country www.youtube.com 4)" \
"$(dns_country www.youtube.com 6)"

echo
