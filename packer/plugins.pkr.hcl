packer {
  required_plugins {
    xenserver = {
      version = ">= v0.9.0"
      source  = "github.com/vatesfr/xenserver"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}
