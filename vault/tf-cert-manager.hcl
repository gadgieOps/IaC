# Policy to allow creation and management of policies
path "sys/policies/acl/*" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

# Policy to allow management of Kubernetes auth roles
path "auth/kubernetes/role/*" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "auth/kubernetes/config" {
  capabilities = ["read"]
}

path "auth/token/create" {  
  capabilities = ["create", "update", "sudo"]  
}
