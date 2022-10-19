resource "azurerm_resource_group" "rg" {
  name     = "myrg_fromTF"
  location = "East US"
  tags = {
    environment = "RG_TF_staging"
  }
}

resource "azurerm_storage_account" "sg_acc" {
  name                     = "mysgaccfromtfqq"
  resource_group_name      = "myrg_fromTF"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "sg_acc_staging"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}