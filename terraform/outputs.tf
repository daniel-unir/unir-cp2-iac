output "ip_publica" {
  value       = azurerm_public_ip.public_ip-unir-casopractico2.ip_address
  sensitive   = false
}
output "vm_ssh_key" {
  value       = tls_private_key.sshkey-unir-casopractico2.private_key_openssh
  sensitive   = true
}
output "acr_url" {
  value       = azurerm_container_registry.acr-unir-casopractico2.login_server
  sensitive   = false
}
output "acr_user" {
  value       = azurerm_container_registry.acr-unir-casopractico2.admin_username
  sensitive   = false
}
output "acr_pwd" {
  value       = azurerm_container_registry.acr-unir-casopractico2.admin_password
  sensitive   = true
}
