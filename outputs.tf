 output "server_info" {
    value = azurerm_linux_virtual_machine.virtual_machines[*].public_ip_address
  }