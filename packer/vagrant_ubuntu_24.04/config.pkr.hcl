packer {
  required_version = ">= 1.12.0"

  required_plugins {
    vagrant = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "vagrant" "noble" {
  communicator = "ssh"
  source_path  = "bento/ubuntu-24.04"
  provider     = "vmware_desktop"
  add_force    = true
}

build {
  sources = ["source.vagrant.noble"]

  name = "ubuntu-24.04"

  provisioner "shell" {
    inline = ["sudo cloud-init clean --machine-id"]
  }
}