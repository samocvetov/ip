#!/usr/bin/env bash

TIMEOUT=4

# Получение публичных IP
get_ipv4() {
    curl -4 -s --max-time $TIMEOUT https://api.ipify.org
}

get_ipv6() {
    curl -6 -s --max-time $TIMEOUT https://api64.ipify.org
}

# Страна по IP
get_country() {
    IP=$1
    [[ -z "$IP" ]] && echo "N/A" && return
    curl -s --max-time $TIMEOUT https://ipinfo.io/$IP/country 2>/dev/null | head -n1
}

# ASN по IP
get_asn() {
    IP=$1
    [[ -z "$IP" ]] && echo "N/A" && return
    curl -s --max-time $TIMEOUT https://ipinfo.io/$IP/org 2>/dev/null | head -n1
}

# Проверка сервиса через DNS (как ipregion)
service_country() {
    HOST=$1
    TYPE=$2

    if [ "$TYPE" = "4" ]; then
        IP=$(dig +short A $HOST | head -n1)
    else
        IP=$(dig +short AAAA $HOST | head -n1)
    fi

    [[ -z "$IP" ]] && echo "N/A" && return
    get_country "$IP"
}

# Проверка dig
if ! command -v dig >/dev/null 2>&1; then
    sudo apt install dnsutils -y >/dev/null 2>&1
fi

echo "Made with <3 by ipregion-clone"
echo

IP4=$(get_ipv4)
IP6=$(get_ipv6)

C4=$(get_country "$IP4")
C6=$(get_country "$IP6")
ASN=$(get_asn "$IP4")

echo "IPv4: ${IP4:-N/A}, registered in ${C4:-N/A}"
echo "IPv6: ${IP6:-N/A}, registered in ${C6:-N/A}"
echo "ASN: ${ASN:-N/A}"
echo
echo "Popular services"
echo
printf "%-22s %-5s %-5s\n" "Service" "IPv4" "IPv6"

printf "%-22s %-5s %-5s\n" \
"Google" \
"$(service_country www.google.com 4)" \
"$(service_country www.google.com 6)"

printf "%-22s %-5s %-5s\n" \
"YouTube" \
"$(service_country www.youtube.com 4)" \
"$(service_country www.youtube.com 6)"

echo
