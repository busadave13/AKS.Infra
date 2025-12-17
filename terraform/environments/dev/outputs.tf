# Dev Environment Outputs

# Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Networking
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.networking.aks_subnet_id
}

# ACR
output "acr_name" {
  description = "Name of the container registry"
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "Login server URL of the container registry"
  value       = module.acr.acr_login_server
}

# AKS
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "aks_node_resource_group" {
  description = "Name of the AKS node resource group"
  value       = module.aks.node_resource_group
}

# Monitoring - Log Analytics
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.monitoring.log_analytics_workspace_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = module.monitoring.log_analytics_workspace_name
}

# Monitoring - Prometheus
output "prometheus_workspace_id" {
  description = "ID of the Azure Monitor workspace for Prometheus"
  value       = module.monitoring.monitor_workspace_id
}

output "prometheus_workspace_name" {
  description = "Name of the Azure Monitor workspace for Prometheus"
  value       = module.monitoring.monitor_workspace_name
}

output "prometheus_query_endpoint" {
  description = "Query endpoint of the Azure Monitor workspace for Prometheus"
  value       = module.monitoring.monitor_workspace_query_endpoint
}

# Monitoring - Grafana
output "grafana_id" {
  description = "ID of the Azure Managed Grafana instance"
  value       = module.monitoring.grafana_id
}

output "grafana_name" {
  description = "Name of the Azure Managed Grafana instance"
  value       = module.monitoring.grafana_name
}

output "grafana_endpoint" {
  description = "Endpoint URL of the Azure Managed Grafana instance"
  value       = module.monitoring.grafana_endpoint
}

# Helpful commands output
output "get_credentials_command" {
  description = "Azure CLI command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.aks.cluster_name}"
}

output "acr_login_command" {
  description = "Azure CLI command to login to ACR"
  value       = "az acr login --name ${module.acr.acr_name}"
}

output "grafana_access_info" {
  description = "Information about accessing Azure Managed Grafana"
  value       = var.grafana_enabled ? "Access Grafana at: ${module.monitoring.grafana_endpoint} (Azure AD authentication required)" : "Grafana is not enabled"
}
