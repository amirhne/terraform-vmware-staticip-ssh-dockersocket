terraform {
  required_providers {
    vsphere = {
      source = "vmware/vsphere"
      version = "2.15.0"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed certificate
  allow_unverified_ssl = true
}
