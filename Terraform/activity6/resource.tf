resource "azurerm_resource_group" "rgvn" {
  name     = var.rg_name
  location = var.location
  tags = {
    environment = "RG_TF_staging"
  }
}