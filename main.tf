# Create public IP
resource "azurerm_public_ip" "public_ip" {
  count = length(var.pawprints)
  name                = "${var.pawprints[count.index]}_public_ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  count = length(var.pawprints)
  name                = "${var.pawprints[count.index]}_nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.pawprints[count.index]}_nic_config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_group" {
  count = length(var.pawprints)
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = var.security_group_id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "virtual_machines" {
  count = length(var.pawprints)
  name                  = "${var.pawprints[count.index]}"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = "Standard_B1ls"

  os_disk {
    name                 = "${var.pawprints[count.index]}_root_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "it3850"
    public_key = var.public_key
  }

  computer_name  = "${var.pawprints[count.index]}"
  admin_username = var.admin_username
  disable_password_authentication = true
}