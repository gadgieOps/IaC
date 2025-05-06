terraform {
  backend "s3" {
    bucket       = "gadgieops-yem-tfstate"
    key          = "vault-engine.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}