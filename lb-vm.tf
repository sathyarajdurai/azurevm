resource "azurerm_public_ip" "lb_ip" {
  name                = "public_ip_web"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  allocation_method   = "Static"
  sku = "Standard"

  tags = {
    environment = "lab_test"
  }
}


resource "azurerm_lb" "lb_test" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id

  }
  
  sku = "Standard"
}


resource "azurerm_lb_backend_address_pool" "lb_backend" {
  loadbalancer_id = azurerm_lb.lb_test.id
  # virtual_network_id = azurerm_virtual_network.test_vnet.id
  name            = "BackEndAddressPool"
}



resource "azurerm_lb_backend_address_pool_address" "example" {
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend.id
  virtual_network_id      = azurerm_virtual_network.web_vnet.id
  ip_address              = azurerm_network_interface.web_nic.private_ip_address
}


resource "azurerm_lb_probe" "web_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.lb_test.id
}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb_test.frontend_ip_configuration[0].name
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.lb_backend.id]
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.lb_test.id
}



# resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
#   network_interface_id    = azurerm_network_interface.web_nic.id
#   ip_configuration_name   = azurerm_network_interface.web_nic.ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend.id
# }