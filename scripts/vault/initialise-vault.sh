#!/bin/bash
# Enhanced Vault Initialization Script
# Author: Dave
# Description: Initialize and unseal a Vault instance in Kubernetes

set -e  # Exit on error

# Define colors for output
GREEN='\033[38;5;150m'
BLUE='\033[38;5;109m'
RED='\033[38;5;203m'
YELLOW='\033[38;5;222m'
NC='\033[0m'

# Configuration
export VAULT_K8S_NAMESPACE="vault"
export VAULT_HELM_RELEASE_NAME="vault"
export VAULT_SERVICE_NAME="vault-internal"
export K8S_CLUSTER_NAME="cluster.local"
export WORKDIR=/tmp/vault

# Function definitions
function print_banner() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Vault Initialization Tool        ${NC}"
    echo -e "${BLUE}========================================${NC}"
}

function print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

function print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

function print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}" >&2
}

function print_warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
}

function check_prerequisites() {
    print_info "Checking prerequisites..."
    
    if ! command -v kubectl >/dev/null 2>&1; then
        print_error "kubectl not found. Please install kubectl."
        exit 1
    fi
    
    if ! command -v jq >/dev/null 2>&1; then
        print_error "jq not found. Please install jq."
        exit 1
    fi
    
    # Check if namespace exists
    if ! kubectl get namespace "$VAULT_K8S_NAMESPACE" >/dev/null 2>&1; then
        print_error "Namespace $VAULT_K8S_NAMESPACE doesn't exist."
        exit 1
    fi
    
    print_success "Prerequisites check passed!"
}

function setup_workdir() {
    print_info "Setting up working directory at $WORKDIR..."
    mkdir -p "$WORKDIR"
    print_success "Working directory ready!"
}

function init_vault() {
    print_info "Initializing Vault..."
    
    if kubectl exec -n "$VAULT_K8S_NAMESPACE" vault-0 -- vault status >/dev/null 2>&1; then
        print_warning "Vault may already be initialized. Proceeding anyway..."
    fi
    
    kubectl exec -n "$VAULT_K8S_NAMESPACE" vault-0 -- vault operator init \
        -key-shares=1 \
        -key-threshold=1 \
        -format=json > "${WORKDIR}/cluster-keys.json"
    
    print_success "Vault initialized! Keys saved to ${WORKDIR}/cluster-keys.json"
}

function unseal_vault() {
    print_info "Extracting unseal key..."
    export VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" "${WORKDIR}/cluster-keys.json")
    print_info "Using unseal key: ${VAULT_UNSEAL_KEY:0:3}...${VAULT_UNSEAL_KEY: -3}"
    
    print_info "Unsealing Vault..."
    kubectl exec -n "$VAULT_K8S_NAMESPACE" vault-0 -- vault operator unseal "$VAULT_UNSEAL_KEY"
    print_success "Vault unsealed successfully!"
}

function print_credentials() {
    local root_token
    root_token=$(jq -r ".root_token" "${WORKDIR}/cluster-keys.json")
    
    print_info "Here are your credentials (also saved in ${WORKDIR}/cluster-keys.json):"
    echo -e "${YELLOW}Unseal Key:${NC} ${VAULT_UNSEAL_KEY}"
    echo -e "${YELLOW}Root Token:${NC} ${root_token}"
    print_warning "Keep these credentials secure!"
}

# Main script
print_banner
check_prerequisites
setup_workdir
init_vault
unseal_vault
print_credentials

print_success "Vault initialization complete!"