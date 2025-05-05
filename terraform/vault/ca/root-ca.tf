resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "Mount PKI secrets engine"

  default_lease_ttl_seconds = 86400
  max_lease_ttl_seconds     = 315360000
}

resource "vault_pki_secret_backend_root_cert" "gadgieRoot" {
  backend               = vault_mount.pki.path
  type                  = "internal"
  common_name           = "gadgieOps ROOT CA"
  key_type              = "rsa"
  key_bits              = 4096
  ttl                   = 315360000
  ou                    = "yem"
  organization          = "gadgieOps"
  country               = "GB"
  issuer_name           = "gadgieRoot"
}

output "vault_pki_secret_backend_root_cert" {
  value = vault_pki_secret_backend_root_cert.gadgieRoot.certificate
}

resource "local_file" "gadgieRoot_ca_cert" {
  content  = vault_pki_secret_backend_root_cert.gadgieRoot.certificate
  filename = "gadgieRoot_ca.crt"
}

resource "vault_pki_secret_backend_issuer" "gadgieRoot" {
   backend                        = vault_mount.pki.path
   issuer_ref                     = vault_pki_secret_backend_root_cert.gadgieRoot.issuer_id
   issuer_name                    = vault_pki_secret_backend_root_cert.gadgieRoot.issuer_name
   revocation_signature_algorithm = "SHA256WithRSA"
}

resource "vault_pki_secret_backend_role" "role" {
   backend          = vault_mount.pki.path
   name             = "gadgieOpsLab"
   ttl              = 86400
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allow_subdomains = true
   allow_any_name   = true
}

resource "vault_pki_secret_backend_config_urls" "config-urls" {
   backend = vault_mount.pki.path
   issuing_certificates    = ["http://vault.gadgieops.yem:32001/v1/pki/ca"]
   crl_distribution_points = ["http://vault.gadgieops.yem:32001/v1/pki/crl"]
}