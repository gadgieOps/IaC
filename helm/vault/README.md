# Hashicorp Vault Helm Chart

This repository contains configuration for deploying Hashicorp Vault on Kubernetes using Helm.

## Configuration

This chart offers various configuration options. Instead of duplicating the documentation, please refer to the official Hashicorp documentation for detailed configuration instructions:

[Vault Helm Chart Documentation](https://developer.hashicorp.com/vault/docs/platform/k8s/helm)

## Install

```bash
# Install
helm install vault hashicorp/vault --version 0.30.0 --create-namespace --namespace vault -f values.yml

# update values
helm upgrade -f values.yml -n vault vault hashicorp/vault

# Uninstall
helm uninstall vault hashicorp/vault --namespace vault
```

## Notes

- Refer to the [official documentation](https://developer.hashicorp.com/vault/docs/platform/k8s/helm) for best practices and advanced configurations

## Additional Resources

- [Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [Vault Kubernetes Integration](https://developer.hashicorp.com/vault/docs/platform/k8s)
- [Vault Helm Chart GitHub Repository](https://github.com/hashicorp/vault-helm)