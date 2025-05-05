kubectl -n vault exec pods/vault-0  -- \
        vault write --tls-skip-verify \
        auth/kubernetes/role/vault-issuer \
        bound_service_account_names=vault-issuer \
        bound_service_account_namespaces=vault \
        audience="vault://vault/vault-issuer" \
        policies=pki \
        ttl=1m