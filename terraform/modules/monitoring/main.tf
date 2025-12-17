# Monitoring Module - Log Analytics, Azure Monitor Workspace, Managed Prometheus, and Managed Grafana

# Log Analytics Workspace for Container Insights
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}

# Log Analytics Solution for Container Insights
resource "azurerm_log_analytics_solution" "containers" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

# Azure Monitor Workspace for Managed Prometheus
resource "azurerm_monitor_workspace" "prometheus" {
  count = var.prometheus_enabled ? 1 : 0

  name                = var.monitor_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Data Collection Endpoint for Prometheus metrics
resource "azurerm_monitor_data_collection_endpoint" "prometheus" {
  count = var.prometheus_enabled ? 1 : 0

  name                          = var.data_collection_endpoint_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "Linux"
  public_network_access_enabled = var.prometheus_public_network_access_enabled

  tags = var.tags
}

# Data Collection Rule for Prometheus metrics
resource "azurerm_monitor_data_collection_rule" "prometheus" {
  count = var.prometheus_enabled ? 1 : 0

  name                        = var.data_collection_rule_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.prometheus[0].id
  kind                        = "Linux"

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.prometheus[0].id
      name               = "MonitoringAccount"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount"]
  }

  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }

  description = "Data collection rule for Prometheus metrics from AKS"

  tags = var.tags
}

# Azure Managed Grafana
resource "azurerm_dashboard_grafana" "main" {
  count = var.grafana_enabled ? 1 : 0

  name                              = var.grafana_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  sku                               = var.grafana_sku
  zone_redundancy_enabled           = var.grafana_zone_redundancy_enabled
  public_network_access_enabled     = var.grafana_public_network_access_enabled
  api_key_enabled                   = var.grafana_api_key_enabled
  deterministic_outbound_ip_enabled = var.grafana_deterministic_outbound_ip_enabled
  grafana_major_version             = var.grafana_major_version

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.prometheus[0].id
  }

  tags = var.tags

  depends_on = [azurerm_monitor_workspace.prometheus]
}

# Role assignment for Grafana to read from Azure Monitor Workspace
resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  count = var.grafana_enabled && var.prometheus_enabled ? 1 : 0

  scope                = azurerm_monitor_workspace.prometheus[0].id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main[0].identity[0].principal_id
}

# Role assignment for Grafana to read monitoring data from subscription
resource "azurerm_role_assignment" "grafana_monitoring_data_reader" {
  count = var.grafana_enabled ? 1 : 0

  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main[0].identity[0].principal_id
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}
