resource "vault_auth_backend" "kubernetes" {
  type        = "kubernetes"
  path        = "kubernetes"
  description = "Kubernetes Auth Engine"
}

resource "vault_auth_backend" "approle" {
  type        = "approle"
  path        = "approle"
  description = "AppRole Auth Engine"
}

resource "vault_mount" "kv_v2" {
  path        = "kvv2"
  type        = "kv"
  description = "Key/Value Version 2 Secret Engine"
  options = {
    version = "2"
  }
}