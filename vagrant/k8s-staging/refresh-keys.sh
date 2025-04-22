#!/bin/bash
# Script to refresh SSH known hosts entries for Vagrant VMs

# Set the known_hosts file location
KNOWN_HOSTS_FILE=~/.ssh/known_hosts

HOSTS=(
    "192.168.6.3"
    "192.168.6.4"
    "192.168.6.5"
)

# Parse arguments for quiet mode
QUIET_MODE=false
for arg in "$@"; do
    if [ "$arg" = "--quiet" ] || [ "$arg" = "-q" ]; then
        QUIET_MODE=true
    fi
done

# Function to conditionally echo messages
function log_msg() {
    if [ "$QUIET_MODE" = false ]; then
        echo "$@"
    fi
}

function refresh_host() {
    local HOST=$1
    log_msg "Processing $HOST..."
    
    # Remove existing entries for this host
    if [ "$QUIET_MODE" = true ]; then
        ssh-keygen -R "$HOST" >/dev/null 2>&1
    else
        ssh-keygen -R "$HOST" 2>/dev/null
    fi
    
    # Add new fingerprint
    if [ "$QUIET_MODE" = true ]; then
        ssh-keyscan -H "$HOST" >> "$KNOWN_HOSTS_FILE" >/dev/null 2>&1
    else
        ssh-keyscan -H "$HOST" >> "$KNOWN_HOSTS_FILE" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        log_msg "✅ Successfully refreshed keys for $HOST"
    else
        log_msg "❌ Failed to refresh keys for $HOST"
    fi
}

log_msg "Refreshing SSH known hosts entries for Vagrant VMs..."

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

log_msg "SSH known hosts refresh complete!"
