#!/usr/bin/env bash

get_ipv4() {
    curl -4 -s --max-time 4 https://api.ipify.org
}

get_ipv6() {
    curl -6 -s --max-time 4 https://api64.ipify.org
}

get_country() {
    curl -s --max-time 4 ipinfo.io/$1/country 2>/dev/null
}

get_asn() {
    curl -s --max-time 4 ipinfo.io/$1/org 2>/dev/null
}

check_service() {
    HOST=$1

    IPV4=$(curl -4 -s --connect-timeout 4 https://$HOST -o /dev/null -w "%{remote_ip}")
    IPV6=$(curl -6 -g -s --connect-timeout 4 https://$HOST -o /dev/null -w "%{remote_ip}")

    C4=$(get_country $IPV4)
    C6=$(get_country $IPV6)

    printf "%-20s %-5s %-5s\n" "$2" "${C4:-N/A}" "${C6:-N/A}"
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
printf "%-20s %-5s %-5s\n" "Service" "IPv4" "IPv6"

check_service "www.google.com" "Google"
check_service "www.youtube.com" "YouTube"

echo
