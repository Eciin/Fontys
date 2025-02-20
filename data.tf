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
  name          = "NIM01-9"
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


