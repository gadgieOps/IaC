terraform {
  backend "s3" {
    bucket = "gadgieops-yem-tfstate"
    key    = "vault-ca.tfstate"
    region = "eu-west-2"
    use_lockfile = true
  }
}