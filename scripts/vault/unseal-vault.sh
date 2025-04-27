#!/bin/bash

BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NORD_FROST='\033[38;5;109m'
NORD_SNOWSTORM='\033[38;5;253m'
RESET='\033[0m'

echo -e "${NORD_FROST}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${RESET}"
echo -e "${NORD_FROST}┃${BLUE} ⚡ Vault Unseal Operation Initiated ⚡ ${NORD_FROST}┃${RESET}"
echo -e "${NORD_FROST}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${RESET}"

echo -e "${CYAN}▶ Unsealing Vault pod: ${GREEN}vault-0${RESET}"
kubectl exec -n vault vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Vault unsealed successfully${RESET}"
else
    echo -e "\033[0;31m✗ Failed to unseal Vault${RESET}"
fi