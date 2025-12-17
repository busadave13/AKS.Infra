# Dev Environment Variables

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westus2"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = null
}

variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs for cluster admin access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ACR Configuration
variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique, alphanumeric only)"
  type        = string
}

# Prometheus Configuration
variable "prometheus_enabled" {
  description = "Enable Azure Managed Prometheus"
  type        = bool
  default     = true
}

variable "prometheus_public_network_access_enabled" {
  description = "Enable public network access for Prometheus data collection endpoint"
  type        = bool
  default     = true
}

# Grafana Configuration
variable "grafana_enabled" {
  description = "Enable Azure Managed Grafana"
  type        = bool
  default     = true
}

variable "grafana_sku" {
  description = "SKU for Azure Managed Grafana (Standard or Essential)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Essential"], var.grafana_sku)
    error_message = "Grafana SKU must be either 'Standard' or 'Essential'."
  }
}

variable "grafana_zone_redundancy_enabled" {
  description = "Enable zone redundancy for Grafana"
  type        = bool
  default     = false
}

variable "grafana_public_network_access_enabled" {
  description = "Enable public network access for Grafana"
  type        = bool
  default     = false
}
