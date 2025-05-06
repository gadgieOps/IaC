# Policy to allow initializing and managing auth and secrets engines in Vault

path "sys/auth/*" {
    capabilities = ["create", "update", "read", "delete", "list", "sudo"]
}

path "sys/auth" {
    capabilities = ["read", "list"]
}

path "sys/mounts/*" {
    capabilities = ["create", "update", "read", "delete", "list", "sudo"]
}

path "sys/mounts" {
    capabilities = ["read", "list"]
}

path "sys/health" {
    capabilities = ["read"]
}

path "auth/token/create" {  
  capabilities = ["create", "update", "sudo"]  
}