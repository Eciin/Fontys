terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  user           = VAR_vsphere_user
  password       = VAR_vsphere_password
  vsphere_server = VAR_vsphere_server
}
