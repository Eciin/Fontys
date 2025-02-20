resource "vsphere_virtual_machine" "Server" {
  name             = "Monitoring Server"
  folder           = "_Courses/I3-DB01/i416434"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
 
  num_cpus = 2
  memory   = 4096
 
  guest_id = "ubuntu64Guest"
 
  wait_for_guest_net_timeout = 120
  wait_for_guest_ip_timeout  = 120
 
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
  name             = "Client"
  folder           = "_Courses/I3-DB01/i416434"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
 
  num_cpus = 2
  memory   = 4096
 
  guest_id = "ubuntu64Guest"
 
  wait_for_guest_net_timeout = 120
  wait_for_guest_ip_timeout  = 120
 
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
output "vm_ips" {
  value = [
    vsphere_virtual_machine.Server.default_ip_address,
    vsphere_virtual_machine.Desktop.default_ip_address
  ]
}

resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [Server]
    ${vsphere_virtual_machine.Server.default_ip_address} ansible_user=student ansible_password=student ansible_become_pass=student
    [Desktop]
    ${vsphere_virtual_machine.Desktop.default_ip_address} ansible_user=student ansible_password=student ansible_become_pass=student
  EOT
  filename = "inventory.ini"
}

resource "null_resource" "ansible_provision" {
  depends_on = [vsphere_virtual_machine.Server, vsphere_virtual_machine.Desktop]  

  provisioner "local-exec" {  
    command = " sudo ansible-playbook -i inventory.ini playbook.yaml --ask-become-pass"  
  }
}