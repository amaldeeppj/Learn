resource "azurerm_resource_group" "newrgFromTF" {
    name = var.resource_group.name
    location = var.resource_group.location
  
}
