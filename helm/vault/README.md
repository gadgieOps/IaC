# Hashicorp Vault Helm Chart

This repository contains configuration for deploying Hashicorp Vault on Kubernetes using Helm.

## Dependencies

### Initial TLS Setup

Vault will eventually become the CA for the lab, this is one of the larger chicken and gg situations. To initially setup vault use the following script to generate the vault certificates upload to the vault namespace as a secret.

Script: scripts/setup-vault-tls.sh

After vault is functional, terraform/vault/ca is used to enable the CA functionality of vault. helm/cert-manager is then installed and used to request certificates from the vault CA. Once a cert-manager instance is up and running in the vault namespace, the secret changed in the vault values.yml and vault becomes the CA for itself.

See: [Kubernetes TLS Guide](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-tls)

## Configuration

This chart offers various configuration options. Instead of duplicating the documentation, please refer to the official Hashicorp documentation for detailed configuration instructions:

[Vault Helm Chart Documentation](https://developer.hashicorp.com/vault/docs/platform/k8s/helm)

## Useful Commands

```bash
# Install
helm install vault hashicorp/vault --version 0.30.0 --create-namespace --namespace vault -f values.yml

# update values
helm upgrade -f values.yml -n vault vault hashicorp/vault

# recycle server pods
kubectl delete pod -n vault -l component=server

# launch a shell in a vault pod
kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh

# Uninstall
helm uninstall vault hashicorp/vault --namespace vault
```

## Notes

- Refer to the [official documentation](https://developer.hashicorp.com/vault/docs/platform/k8s/helm) for best practices and advanced configurations

## Additional Resources

- [Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [Vault Kubernetes Integration](https://developer.hashicorp.com/vault/docs/platform/k8s)
- [Vault Helm Chart GitHub Repository](https://github.com/hashicorp/vault-helm)