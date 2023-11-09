
resource "azurerm_linux_virtual_machine" "web_test" {
  name                = "${local.name}-machine"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  size                = "Standard_DS1_V2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.web_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_ssh_public_key.vm_key.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  user_data = base64encode(file("script.sh"))

  # custom_data    = filebase64(data.template_file.linux-vm-cloud-init.rendered)

}

# data "template_file" "linux-vm-cloud-init" {
#   template = file("script.sh")
# }
