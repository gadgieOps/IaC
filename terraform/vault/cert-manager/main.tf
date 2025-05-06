resource "vault_policy" "pki" {
  name   = "pki"
  policy = <<EOT
path "pki_int*" {
    capabilities = ["read", "list"]
}

path "pki_int/sign/gadgieops.yem" {
    capabilities = ["create", "update"]
}

path "pki_int/issue/gadgieops.yem" {
    capabilities = ["create"]
}
EOT
}

module "vault" {
  source = "./modules/cert-issuer"
  name   = "vault"
}

module "longhorn" {
  source = "./modules/cert-issuer"
  name   = "longhorn"
}

module "gitlab" {
  source = "./modules/cert-issuer"
  name   = "gitlab"
}