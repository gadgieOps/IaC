#!/bin/bash
set -e

# Setup Vault with TLS based on the tutorial:
# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-tls

# Colors for output
GREEN='\033[38;5;108m'
BLUE='\033[38;5;67m'
YELLOW='\033[38;5;180m'
RED='\033[38;5;174m'
NC='\033[0m'

# Function for logging
log() {
    local level=$1
    local message=$2
    local color=$NC
    
    case $level in
        "INFO") color=$BLUE ;;
        "SUCCESS") color=$GREEN ;;
        "WARN") color=$YELLOW ;;
        "ERROR") color=$RED ;;
    esac
    
    echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${color}${level}${NC}: ${message}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
for cmd in openssl kubectl base64 tr; do
    if ! command_exists $cmd; then
        log "ERROR" "$cmd is required but not installed. Please install it first."
        exit 1
    fi
done

log "INFO" "Starting Vault TLS setup..."

# Setup environment
export VAULT_K8S_NAMESPACE="vault"
export VAULT_HELM_RELEASE_NAME="vault"
export VAULT_SERVICE_NAME="vault-internal"
export K8S_CLUSTER_NAME="cluster.local"
export WORKDIR=/tmp/vault

log "INFO" "Creating working directory at $WORKDIR"
mkdir -p $WORKDIR || { log "ERROR" "Failed to create $WORKDIR"; exit 1; }

# Generate Private Key and CSR
log "INFO" "Generating private key..."
openssl genrsa -out ${WORKDIR}/vault.key 2048 || { log "ERROR" "Failed to generate private key"; exit 1; }

log "INFO" "Creating CSR configuration..."
cat > ${WORKDIR}/vault-csr.conf <<EOF
[req]
default_bits = 2048
prompt = no
encrypt_key = yes
default_md = sha256
distinguished_name = kubelet_serving
req_extensions = v3_req
[ kubelet_serving ]
O = system:nodes
CN = system:node:*.${VAULT_K8S_NAMESPACE}.svc.${K8S_CLUSTER_NAME}
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${VAULT_SERVICE_NAME}
DNS.2 = *.${VAULT_SERVICE_NAME}.${VAULT_K8S_NAMESPACE}.svc.${K8S_CLUSTER_NAME}
DNS.3 = *.${VAULT_K8S_NAMESPACE}
IP.1 = 127.0.0.1
EOF

log "INFO" "Generating CSR..."
openssl req -new -key ${WORKDIR}/vault.key -out ${WORKDIR}/vault.csr -config ${WORKDIR}/vault-csr.conf || 
    { log "ERROR" "Failed to generate CSR"; exit 1; }

# Send CSR to Kubernetes
log "INFO" "Creating Kubernetes CSR resource..."
cat > ${WORKDIR}/csr.yaml <<EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
     name: vault.svc
spec:
     signerName: kubernetes.io/kubelet-serving
     expirationSeconds: 8640000
     request: $(cat ${WORKDIR}/vault.csr|base64|tr -d '\n')
     usages:
     - digital signature
     - key encipherment
     - server auth
EOF

kubectl create -f ${WORKDIR}/csr.yaml || { log "ERROR" "Failed to create CSR in Kubernetes"; exit 1; }
log "SUCCESS" "CSR created successfully"

log "INFO" "Approving certificate..."
kubectl certificate approve vault.svc || { log "ERROR" "Failed to approve CSR"; exit 1; }

log "INFO" "Checking CSR status..."
kubectl get csr vault.svc

# Store certificate and key in kubernetes secret store
log "INFO" "Retrieving and processing the signed certificate..."
kubectl get csr vault.svc -o jsonpath='{.status.certificate}' | openssl base64 -d -A -out ${WORKDIR}/vault.crt || 
    { log "ERROR" "Failed to retrieve certificate"; exit 1; }

log "INFO" "Retrieving cluster CA certificate..."
kubectl config view \
    --raw \
    --minify \
    --flatten \
    -o jsonpath='{.clusters[].cluster.certificate-authority-data}' \
    | base64 -d > ${WORKDIR}/vault.ca || { log "ERROR" "Failed to retrieve CA certificate"; exit 1; }

log "INFO" "Creating namespace $VAULT_K8S_NAMESPACE if it doesn't exist..."
kubectl create namespace $VAULT_K8S_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

log "INFO" "Creating Kubernetes secret for Vault TLS..."
kubectl create secret generic vault-ha-tls \
    -n $VAULT_K8S_NAMESPACE \
    --from-file=vault.key=${WORKDIR}/vault.key \
    --from-file=vault.crt=${WORKDIR}/vault.crt \
    --from-file=vault.ca=${WORKDIR}/vault.ca \
    --dry-run=client -o yaml | kubectl apply -f -

log "SUCCESS" "✅ Vault TLS setup completed successfully"
log "INFO" "Temporary files stored in ${WORKDIR}"
