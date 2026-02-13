#!/usr/bin/env bash

TARGET_COUNTRIES="US NL"

get_country() {
    curl -s --max-time 4 ipinfo.io/$1/country 2>/dev/null
}

get_org() {
    curl -s --max-time 4 ipinfo.io/$1/org 2>/dev/null
}

check_service() {
    SERVICE_NAME=$1
    HOST=$2

    for IPVER in 4 6; do
        if [ "$IPVER" = "4" ]; then
            IP=$(curl -$IPVER -s --connect-timeout 4 https://$HOST -o /dev/null -w "%{remote_ip}" 2>/dev/null)
        else
            IP=$(curl -$IPVER -g -s --connect-timeout 4 https://$HOST -o /dev/null -w "%{remote_ip}" 2>/dev/null)
        fi

        if [ -z "$IP" ]; then
            continue
        fi

        COUNTRY=$(get_country $IP)
        ORG=$(get_org $IP)

        MARK=""
        for T in $TARGET_COUNTRIES; do
            if [ "$COUNTRY" = "$T" ]; then
                if [[ "$ORG" == *"Google"* && "$ORG" != *"Cache"* ]]; then
                    MARK="🎯 REAL"
                else
                    MARK="⚠ CDN"
                fi
            fi
        done

        printf "%-10s IPv%s %s %s\n" "$SERVICE_NAME" "$IPVER" "$COUNTRY" "$MARK"
        printf "   → %s | %s\n" "$IP" "$ORG"
    done
    echo
}

echo
echo "Scanning VPS route..."
echo

check_service "Google" "www.google.com"
check_service "YouTube" "www.youtube.com"
