
resource "azurerm_virtual_network" "tfnw" {
  name                = var.nw_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.nw_address
  dns_servers         = var.dns_address
#   subnet {
#     count = 6
#     name           = "subnet[count.index]"
#     address_prefix = "10.0.1.0/24"
#   }

#   subnet {
#     name           = "subnet2"
#     address_prefix = "10.0.2.0/24"
   
#   }

#   subnet {
#     name           = "subnet3"
#     address_prefix = "10.0.3.0/24"
#   }

#   subnet {
#     name           = "subnet4"
#     address_prefix = "10.0.4.0/24"
   
#   }

#   subnet {
#     name           = "subnet5"
#     address_prefix = "10.0.5.0/24"
#   }

#   subnet {
#     name           = "subnet6"
#     address_prefix = "10.0.6.0/24"
   
#   }

  tags = {
    "name" = "virtual network"
  }
  depends_on = [
    azurerm_resource_group.rgvn
  ]
}
