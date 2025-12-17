# Monitoring Module Outputs

# Log Analytics Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

# Azure Monitor Workspace (Prometheus) Outputs
output "monitor_workspace_id" {
  description = "ID of the Azure Monitor workspace for Prometheus"
  value       = var.prometheus_enabled ? azurerm_monitor_workspace.prometheus[0].id : null
}

output "monitor_workspace_name" {
  description = "Name of the Azure Monitor workspace for Prometheus"
  value       = var.prometheus_enabled ? azurerm_monitor_workspace.prometheus[0].name : null
}

output "monitor_workspace_query_endpoint" {
  description = "Query endpoint of the Azure Monitor workspace"
  value       = var.prometheus_enabled ? azurerm_monitor_workspace.prometheus[0].query_endpoint : null
}

# Data Collection Outputs
output "data_collection_endpoint_id" {
  description = "ID of the data collection endpoint for Prometheus"
  value       = var.prometheus_enabled ? azurerm_monitor_data_collection_endpoint.prometheus[0].id : null
}

output "data_collection_rule_id" {
  description = "ID of the data collection rule for Prometheus"
  value       = var.prometheus_enabled ? azurerm_monitor_data_collection_rule.prometheus[0].id : null
}

# Grafana Outputs
output "grafana_id" {
  description = "ID of the Azure Managed Grafana instance"
  value       = var.grafana_enabled ? azurerm_dashboard_grafana.main[0].id : null
}

output "grafana_name" {
  description = "Name of the Azure Managed Grafana instance"
  value       = var.grafana_enabled ? azurerm_dashboard_grafana.main[0].name : null
}

output "grafana_endpoint" {
  description = "Endpoint URL of the Azure Managed Grafana instance"
  value       = var.grafana_enabled ? azurerm_dashboard_grafana.main[0].endpoint : null
}

output "grafana_identity_principal_id" {
  description = "Principal ID of the Grafana managed identity"
  value       = var.grafana_enabled ? azurerm_dashboard_grafana.main[0].identity[0].principal_id : null
}
