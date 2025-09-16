# Get Datacenter
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

# Get Compute Cluster
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get Datastore
data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get Network
data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get VM Template
data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

locals {
  vm_ips = [for i in range(var.vm_count) : cidrhost("192.168.1.0/24", 5 + i)] # this line starts VM IPs from 192.168.1.6
  default_gw = "192.168.1.1" # Put Your Desired Gateway Here
}

# Create VM from Template
resource "vsphere_virtual_machine" "vm" {
#  wait_for_guest_net_timeout = 0
  count		   = var.vm_count
  name             = "${var.vm_name}_${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.vm_cpu
  memory           = var.vm_memory
  folder	   = var.vm_folder
  firmware         = "efi"
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }


  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/meta-data.tmpl", {
      hostname = "${var.hostname}-${count.index + 1}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/user-data.tmpl", {
      hostname     = "${var.hostname}-${count.index + 1}"
      admin_user   = var.admin_user
      ssh_key      = var.ssh_public_key
      packages     = var.packages
      vm_ip        = local.vm_ips[count.index]
      default_gw   = local.default_gw
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}
output "vm_name_ip_map" {
  description = "Map of VM name to its static IP"
  value = {
    for i in range(var.vm_count) : vsphere_virtual_machine.vm[i].name => local.vm_ips[i]
  }
}
