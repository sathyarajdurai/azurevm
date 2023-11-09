# resource "azurerm_ssh_public_key" "ssh_test" {
#   name                = "web_key"
#   resource_group_name = azurerm_resource_group.web_vm.name
#   location            = "West Europe"
#   public_key          = file("~/.ssh/test.pub")
# }
