resource "vault_kubernetes_auth_backend_role" "issuer_role" {
  backend                          = "kubernetes"
  role_name                        = "${var.name}-issuer"
  bound_service_account_names      = ["${var.name}-issuer"]
  bound_service_account_namespaces = [var.name]
  audience                         = "vault://${var.name}/${var.name}-issuer"
  token_policies                   = ["pki"]
}