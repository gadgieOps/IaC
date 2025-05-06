resource "vault_policy" "gl-pg-user-policy" {
  name   = "gl-pg-user"
  policy = <<EOT
path "kvv2/data/gl-pg-user/config" {
    capabilities = ["read", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "gl_pg_user_role" {
  role_name                        = "gl-pg-user"
  backend                          = "kubernetes"
  bound_service_account_names      = ["gl-pg-user-sa"]
  bound_service_account_namespaces = ["gitlab"]
  token_policies                   = [vault_policy.gl-pg-user-policy.name]
}