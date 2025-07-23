resource "azurerm_virtual_network" "vnet-unir-casopractico2" {
  name                = "vnet-unir-casopractico2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-unir-casopractico2.location
  resource_group_name = azurerm_resource_group.rg-unir-casopractico2.name
}

resource "azurerm_subnet" "subnet-unir-casopractico2" {
  name                 = "subnet-unir-casopractico2"
  resource_group_name  = azurerm_resource_group.rg-unir-casopractico2.name
  virtual_network_name = azurerm_virtual_network.vnet-unir-casopractico2.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic-unir-casopractico2" {
  name                = "nic-unir-casopractico2"
  location            = azurerm_resource_group.rg-unir-casopractico2.location
  resource_group_name = azurerm_resource_group.rg-unir-casopractico2.name

  ip_configuration {
    name                          = "ipconf-unir-casopractico2"
    subnet_id                     = azurerm_subnet.subnet-unir-casopractico2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip-unir-casopractico2.id
  }
}

resource "azurerm_network_security_group" "sg-unir-casopractico2" {
  name                = "sg-unir-casopractico2"
  location            = azurerm_resource_group.rg-unir-casopractico2.location
  resource_group_name = azurerm_resource_group.rg-unir-casopractico2.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "sga-unir-casopractico2" {
  network_interface_id      = azurerm_network_interface.nic-unir-casopractico2.id
  network_security_group_id = azurerm_network_security_group.sg-unir-casopractico2.id
}

resource "azurerm_public_ip" "public_ip-unir-casopractico2" {
  name                = "public_ip-unir-casopractico2"
  resource_group_name = azurerm_resource_group.rg-unir-casopractico2.name
  location            = azurerm_resource_group.rg-unir-casopractico2.location
  allocation_method   = "Static"
}

resource "tls_private_key" "sshkey-unir-casopractico2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm-unir-casopractico2" {
  name                = "vm-unir-casopractico2"
  resource_group_name = azurerm_resource_group.rg-unir-casopractico2.name
  location            = azurerm_resource_group.rg-unir-casopractico2.location
  size                = "Standard_F2"
  admin_username      = "daniel-unir"
  network_interface_ids = [ azurerm_network_interface.nic-unir-casopractico2.id ]

  admin_ssh_key {
    username   = "daniel-unir"
    public_key = tls_private_key.sshkey-unir-casopractico2.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
