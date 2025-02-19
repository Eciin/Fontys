terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
}

data "vsphere_datacenter" "dc" {
  name = "Netlab-DC"
}
 
data "vsphere_compute_cluster" "cluster" {
  name          = "Netlab-Cluster-B"
  datacenter_id = data.vsphere_datacenter.dc.id
}
 
data "vsphere_resource_pool" "pool" {
  name          = "i416434"
  datacenter_id = data.vsphere_datacenter.dc.id
}
 
data "vsphere_datastore" "datastore" {
  name          = "NIM01-I3-DB"
  datacenter_id = data.vsphere_datacenter.dc.id
}
 
data "vsphere_network" "network_internet" {
  name          = "0124_Internet-DHCP-192.168.124.0_24"
  datacenter_id = data.vsphere_datacenter.dc.id
}
 
data "vsphere_virtual_machine" "Server" {
  name          = "_Templates/All Courses/Templ_Ubuntu-Linux_Server_22.04.4"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "Desktop" {
  name          = "_Templates/All Courses/Templ_Ubuntu-Linux_Desktop_22.04"
  datacenter_id = data.vsphere_datacenter.dc.id
}
 
resource "vsphere_virtual_machine" "Server" {
  name             = "ubuntu-student"
  folder           = "_Courses/I3-DB01/i416434"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
 
  num_cpus = 2
  memory   = 4096
 
  guest_id = "ubuntu64Guest"
 
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
 
  network_interface {
    network_id   = data.vsphere_network.network_internet.id
    adapter_type = "vmxnet3"
  }
 
  disk {
    label            = "disk0"
    size             = 90
    eagerly_scrub    = false
    thin_provisioned = true
  }
 
  clone {
    template_uuid = data.vsphere_virtual_machine.Server.id
    linked_clone  = false
 
    customize {
      linux_options {
        host_name = "Monitoring-Server"
        domain    = "local"
      }
      network_interface {
        ipv4_address = "" # Use DHCP
        ipv4_netmask = 0  # Use DHCP
      }
    }
  }
}

resource "vsphere_virtual_machine" "Desktop" {
  name             = "ubuntu-student"
  folder           = "_Courses/I3-DB01/i416434"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
 
  num_cpus = 2
  memory   = 4096
 
  guest_id = "ubuntu64Guest"
 
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
 
  network_interface {
    network_id   = data.vsphere_network.network_internet.id
    adapter_type = "vmxnet3"
  }
 
  disk {
    label            = "disk0"
    size             = 90
    eagerly_scrub    = false
    thin_provisioned = true
  }
 
  clone {
    template_uuid = data.vsphere_virtual_machine.Desktop.id
    linked_clone  = false
 
    customize {
      linux_options {
        host_name = "Client"
        domain    = "local"
      }
      network_interface {
        ipv4_address = "" # Use DHCP
        ipv4_netmask = 0  # Use DHCP
      }
    }
  }
}