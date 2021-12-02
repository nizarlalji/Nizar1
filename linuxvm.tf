provider "azurerm" {
    features {}
 subscription_id = "72d0fedb-2a9e-498c-8ff4-4db198c0e5fc"
  client_id       = "3ab694eb-121d-46b9-bb3e-7afcd0880944"
  client_secret   = "I54gurWErTzM-3nPpR5AWthmu1hmU5Avlq"
  tenant_id       = "944ef4c6-3f1e-42a0-b4fb-df07287840fa"
}

resource "azurerm_resource_group" "example" {
  name     = "terratech"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "terravnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "pip2"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "vm1-nic2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id 
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine2"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "ramkumar"
  admin_password      = "Pa$$w0rd7890"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

output "myvm" {
    value = azurerm_linux_virtual_machine.example.id

}
output "mypip" {
value = azurerm_public_ip.example.ip_address

}

output "myip" {
value = azurerm_linux_virtual_machine.example.private_ip_address
}
    
