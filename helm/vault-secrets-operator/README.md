# Install Vault Secrets Operator

## Useful Commands

```sh
# Install
helm install vault-secrets-operator hashicorp/vault-secrets-operator -n vault-so --create-namespace --values values.yml

# Upgrade
helm upgrade vault-secrets-operator hashicorp/vault-secrets-operator -n vault-so --values values.yml
```

## Documentation

[https://developer.hashicorp.com/vault/tutorials/kubernetes/vault-secrets-operator](https://developer.hashicorp.com/vault/tutorials/kubernetes/vault-secrets-operator)
