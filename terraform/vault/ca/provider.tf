terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.8.0"
    }
  }
}

provider "vault" {
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.TF_VAR_role_id
      secret_id = var.TF_VAR_secret_id
    }
  }
}