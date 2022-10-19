variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_location" {
  type        = string
  description = "Location of the resource"
}

variable "azurerm_virtual_network_name" {
  type        = string
  description = "Name of virtual network"
}


variable "vn_address_space" {
  type        = list(string)
  description = "Virtual network address space"
}

variable "dns_server_ips" {
  type        = list(string)
  description = "DNS server IP"
}

variable "subnet1" {
  type        = string
  description = "subnetwork1 address space"
}

variable "subnet2" {
  type        = string
  description = "subnetwork2 address space"
}
