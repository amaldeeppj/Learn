resource "azurerm_resource_group" "rgvn" {
  name     = "myrgvn_fromTF"
  location = "East US"
  tags = {
    environment = "RG_TF_staging"
  }
}


resource "azurerm_virtual_network" "tfnw" {
  name                = "networkfrmterra"
  location            = "East US"
  resource_group_name = "myrgvn_fromTF"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
   
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }

  subnet {
    name           = "subnet4"
    address_prefix = "10.0.4.0/24"
   
  }

  subnet {
    name           = "subnet5"
    address_prefix = "10.0.5.0/24"
  }

  subnet {
    name           = "subnet6"
    address_prefix = "10.0.6.0/24"
   
  }

  tags = {
    "name" = "virtual network"
  }
  depends_on = [
    azurerm_resource_group.rgvn
  ]
}
