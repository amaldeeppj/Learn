resource "azurerm_subnet" "subnet_new" {
  count = 6
  
  resource_group_name = var.rg_name
  virtual_network_name = var.nw_name
  name = "subnet_${count.index}"
  address_prefixes = ["10.0.${count.index}.0/24"]

  depends_on = [
    azurerm_virtual_network.tfnw
  ]
}



