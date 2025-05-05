# Setup Cert Manager

## Based on

[Vault Authentication Method - Kubernetes Auth](https://cert-manager.io/docs/configuration/vault/#option-2-vault-authentication-method-use-kubernetes-auth)

[Certificate Usage Documentation](https://cert-manager.io/docs/usage/certificate/)

## Example Vault Policy

```bash
vault policy write pki - <<EOF
path "pki_int*"             { capabilities = ["read", "list"] }
path "pki_int/sign/test"    { capabilities = ["create", "update"] }
path "pki_int/issue/test"   { capabilities = ["create"] }
EOF
```
