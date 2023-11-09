terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate598rx"
    container_name       = "tfstate"
    key                  = "vm.terraform.tfstate"
  }
}


