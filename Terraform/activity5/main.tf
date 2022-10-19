resource "azurerm_resource_group" "rgvn" {
  name     = var.resource_group_name
  location = var.resource_location
  tags = {
    environment = "RG_TF_staging"
  }
}


resource "azurerm_virtual_network" "tfnw" {
  name                = var.azurerm_virtual_network_name
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  address_space       = var.vn_address_space
  dns_servers         = var.dns_server_ips
  subnet {
    name           = "subnet1"
    address_prefix = var.subnet1
  }

  subnet {
    name           = "subnet2"
    address_prefix = var.subnet2
   
  }

  tags = {
    "name" = "virtual network"
  }
  depends_on = [
    azurerm_resource_group.rgvn
  ]
}
