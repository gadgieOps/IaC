# terraform {
#   backend "local" {
#     path = "remote-backend.tfstate"
#   }
# }

terraform {
  backend "s3" {
    bucket       = "gadgieops-yem-tfstate"
    key          = "talos-dev.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}