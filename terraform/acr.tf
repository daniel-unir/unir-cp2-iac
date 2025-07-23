resource "azurerm_container_registry" "acr-unir-casopractico2" {
  name                = "acrunircasopractico2"
  resource_group_name = azurerm_resource_group.rg-unir-casopractico2.name
  location            = azurerm_resource_group.rg-unir-casopractico2.location
  sku                 = "Basic"
  admin_enabled       = true
}
