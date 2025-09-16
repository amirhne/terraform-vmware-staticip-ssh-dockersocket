variable "vsphere_user" {
  description = "vCenter username"
  type        = string
}

variable "vsphere_password" {
  description = "vCenter password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vCenter server hostname or IP"
  type        = string
}

variable "datacenter" {
  description = "vSphere datacenter name"
  type        = string
}

variable "cluster" {
  description = "vSphere cluster name"
  type        = string
}

variable "datastore" {
  description = "Datastore to deploy VM"
  type        = string
}

variable "network" {
  description = "Network/port group name"
  type        = string
}

variable "template_name" {
  description = "Name of VM template to clone from"
  type        = string
}

variable "vm_name" {
  description = "Name of the new VM"
  type        = string
}

variable "hostname" {
  description = "Name of the new VM"
  type        = string
}

variable "vm_cpu" {
  description = "Number of CPUs"
  type        = number
  default     = 2
}

variable "vm_count" {
  description = "Number of VMs to Clone"
  type        = number
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "packages" {
  description = "List of packages to install"
  type        = list(string)
  default     = ["curl", "htop"]
}

variable "admin_user" {
  description = "Admin username to create"
  type        = string
  default     = "barezpakhsh"
}

variable "ssh_public_key" {
  description = "SSH public key for admin user"
  type        = string
}

variable "vm_folder" {
  description = "VM folder in vCenter"
  type        = string
  default     = "Discovered virtual machine"
}

