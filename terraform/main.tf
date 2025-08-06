resource "azurerm_resource_group" "resource-group" {
  name     = "test-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "virtual-network1" {
  name                = "test-vnet1"
  address_space       = ["10.0.0.0/29"]
  location            = "East US"
  resource_group_name = azurerm_resource_group.resource-group.name
}
resource "azurerm_virtual_network" "virtual-network2" {
  name                = "test-vnet2"
  address_space       = ["10.0.1.0/29"]
  location            = "West US 2"
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network1.name
  address_prefixes     = ["10.0.0.0/29"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network2.name
  address_prefixes     = ["10.0.1.0/29"]
}

resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = "East US"
  resource_group_name = azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "nic2"
  location            = "West US 2"
  resource_group_name = azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

module "vm1" {

source                = "./modules/compute"
  name                  = "vm1"
  resource_group_name   = azurerm_resource_group.resource-group.name
  location              = azurerm_resource_group.resource-group.location
  admin_username        = "adminuser"
  disable_password_authentication = false
  admin_password        = "Admin@!23"
  network_interface_ids = [azurerm_network_interface.nic1.id]
}
module "vm2" {

source                = "./modules/compute"
  name                  = "vm2"
  resource_group_name   = azurerm_resource_group.resource-group.name
  location              = "West US 2"
  admin_username        = "adminuser"
  disable_password_authentication = false
  admin_password        = "Admin@!23"
  network_interface_ids = [azurerm_network_interface.nic2.id]
}
