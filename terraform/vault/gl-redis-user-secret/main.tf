resource "vault_policy" "gl-redis-user-policy" {
  name   = "gl-redis-user"
  policy = <<EOT
path "kvv2/data/gl-redis-user/config" {
    capabilities = ["read", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "gl_redis_user_role" {
  role_name                        = "gl-redis-user"
  backend                          = "kubernetes"
  bound_service_account_names      = ["gl-redis-user-sa"]
  bound_service_account_namespaces = ["gitlab"]
  token_policies                   = [vault_policy.gl-redis-user-policy.name]
}