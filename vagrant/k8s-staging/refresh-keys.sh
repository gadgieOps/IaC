#!/bin/bash
# Script to refresh SSH known hosts entries for Vagrant VMs

# Set the known_hosts file location
KNOWN_HOSTS_FILE=~/.ssh/known_hosts

HOSTS=(
    "192.168.6.3"
    "192.168.6.4"
    "192.168.6.5"
)

GREEN='\033[38;5;108m'
RED='\033[38;5;203m'
YELLOW='\033[38;5;214m'
BLUE='\033[38;5;67m'
BOLD='\033[1m'
RESET='\033[0m'

function refresh_host() {
    local HOST=$1
    echo -e "${BLUE}${BOLD}⚙️  Processing ${YELLOW}$HOST${BLUE}...${RESET}"
    
    ssh-keygen -R "$HOST" 2>/dev/null
    ssh-keyscan -H "$HOST" >> "$KNOWN_HOSTS_FILE"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${BOLD}✅ Successfully refreshed keys for ${YELLOW}$HOST${RESET}"
    else
        echo -e "${RED}${BOLD}❌ Failed to refresh keys for ${YELLOW}$HOST${RESET}"
    fi
    echo ""
}

echo -e "\n${BOLD}${BLUE}🔄 Refreshing SSH known hosts entries for Vagrant VMs...${RESET}\n"

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

echo -e "${GREEN}${BOLD}🎉 SSH known hosts refresh complete! 🚀${RESET}\n"
