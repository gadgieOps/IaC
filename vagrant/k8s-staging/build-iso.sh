#!/bin/bash

# Define colors and formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# Display banner
echo -e "${BOLD}${BLUE}========================================${RESET}"
echo -e "${BOLD}${BLUE}     Cloud-Init ISO Build Tool          ${RESET}"
echo -e "${BOLD}${BLUE}========================================${RESET}"

# Copy the user-data template to user-data
echo -e "\n${BOLD}[1/3]${RESET} ${YELLOW}Copying user-data template...${RESET}"
cp -v ./seeds/user-data-template ./seeds/user-data

# Replace IPADDRESS placeholder with the computed IP address
IP="192.168.6.$(($1+2))"
echo -e "\n${BOLD}[2/3]${RESET} ${YELLOW}Configuring network settings...${RESET}"
echo -e "   → Setting IP address to: ${GREEN}${IP}${RESET}"
sed -i '' "s/IPADDRESS/$IP/g" ./seeds/user-data


# Build cloud-init ISO
echo -e "\n${BOLD}[3/3]${RESET} ${YELLOW}Creating cloud-init ISO...${RESET}"
mkisofs -output ./seeds/cloud-init-0$1.iso -volid cidata -joliet -rock ./seeds/user-data ./seeds/meta-data

echo -e "\n${GREEN}${BOLD}✅ ISO creation complete!${RESET}"
echo -e "   File: ${BOLD}./seeds/cloud-init-0$1.iso${RESET}\n"