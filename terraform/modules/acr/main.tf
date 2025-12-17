# ACR Module - Azure Container Registry

resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  # Enable anonymous pull for public images (optional, disabled by default)
  anonymous_pull_enabled = false

  tags = var.tags
}
