resource "azurerm_resource_group" "web_rg" {
  name     = local.name
  location = "West Europe"
}

resource "azurerm_virtual_network" "web_vnet" {
  name                = "${local.name}-network"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  address_space       = ["10.0.0.0/16"]
  # dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "lab_test"
  }
}

resource "azurerm_subnet" "web_sub" {
  name                 = "lab_subnet2"
  resource_group_name  = azurerm_resource_group.web_rg.name
  virtual_network_name = azurerm_virtual_network.web_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "web_ip" {
  name                = "public_ip_web1"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  allocation_method   = "Static"

  tags = {
    environment = "lab_test"
  }
}


resource "azurerm_network_interface" "web_nic" {
  name                = "${local.name}-nic"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.web_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_ip.id
  }
}


resource "azurerm_network_security_group" "web_sg" {
  name                = "VmwebSecurityGroup1"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range   = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range   = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "lab_test"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.web_nic.id
  network_security_group_id = azurerm_network_security_group.web_sg.id
}

