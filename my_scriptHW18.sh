#!/bin/bash

# Enter the address to ping
read -p "Enter the address to ping: " host

# Counter for failed attempts
fail_count=0

# Function to perform ping and check the response time
ping_host() {
    ping_time=$(ping -c 1 $host | grep 'time=' | awk -F'time=' '{ print $2 }' | awk '{ print $1 }')

    if [ -z "$ping_time" ]; then
        return 1
    else
        echo $ping_time
        return 0
    fi
}

while true; do
    ping_time=$(ping_host)

    if [ $? -ne 0 ]; then
        echo "Failed to ping $host"
        ((fail_count++))
    else
        if (( $(echo "$ping_time > 100" | bc -l) )); then
            echo "Ping time to $host exceeds 100 ms: ${ping_time} ms"
            fail_count=0
        else
            echo "Ping to $host is ${ping_time} ms"
            fail_count=0
        fi
    fi

    if [ $fail_count -ge 3 ]; then
        echo "Failed to ping $host 3 times in a row."
        fail_count=0
    fi

    sleep 1
done
