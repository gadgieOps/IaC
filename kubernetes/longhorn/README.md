# Setup Cert Manager for Longhorn

## Vault role

```sh
kubectl -n vault exec pods/vault-0  -- \
        vault write --tls-skip-verify \
        auth/kubernetes/role/longhorn-issuer \
        bound_service_account_names=longhorn-issuer \
        bound_service_account_namespaces=longhorn \
        audience="vault://longhorn/longhorn-issuer" \
        policies=pki \
        ttl=1m
```

## Documentation

[Cert Manager Vault Authentication Documentation](https://cert-manager.io/docs/configuration/vault/#option-2-vault-authentication-method-use-kubernetes-auth)
