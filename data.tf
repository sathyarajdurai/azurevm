data "azurerm_ssh_public_key" "vm_key" {
  name                = "webtest"
  resource_group_name = "tfstate"
}

output "id" {
  value = data.azurerm_ssh_public_key.vm_key.id
}