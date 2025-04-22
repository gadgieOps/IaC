#!/bin/bash
# Script to refresh SSH known hosts entries for Vagrant VMs

# Set the known_hosts file location
KNOWN_HOSTS_FILE=~/.ssh/known_hosts

HOSTS=(
    "192.168.6.3"
    "192.168.6.4"
    "192.168.6.5"
)

function refresh_host() {
    local HOST=$1
    echo "Processing $HOST..."
    
    ssh-keygen -R "$HOST" 2>/dev/null
    ssh-keyscan -H "$HOST" >> "$KNOWN_HOSTS_FILE"

    if [ $? -eq 0 ]; then
        echo "✅ Successfully refreshed keys for $HOST"
    else
        echo "❌ Failed to refresh keys for $HOST"
    fi
}

echo "Refreshing SSH known hosts entries for Vagrant VMs..."

# Check if an argument was provided
if [ $# -eq 1 ]; then
    # Process just the provided host
    refresh_host "$1"
else
    # Process all hosts in the array
    for HOST in "${HOSTS[@]}"; do
        refresh_host "$HOST"
    done
fi

echo "SSH known hosts refresh complete!"
