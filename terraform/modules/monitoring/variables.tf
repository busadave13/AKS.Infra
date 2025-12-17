# Monitoring Module Variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

# Log Analytics Variables
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "retention_in_days" {
  description = "Retention period for logs in days"
  type        = number
  default     = 30
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

# Prometheus Variables
variable "prometheus_enabled" {
  description = "Enable Azure Managed Prometheus"
  type        = bool
  default     = true
}

variable "monitor_workspace_name" {
  description = "Name of the Azure Monitor workspace for Prometheus"
  type        = string
  default     = ""
}

variable "data_collection_endpoint_name" {
  description = "Name of the data collection endpoint for Prometheus"
  type        = string
  default     = ""
}

variable "data_collection_rule_name" {
  description = "Name of the data collection rule for Prometheus"
  type        = string
  default     = ""
}

variable "prometheus_public_network_access_enabled" {
  description = "Enable public network access for Prometheus data collection endpoint"
  type        = bool
  default     = true
}

# Grafana Variables
variable "grafana_enabled" {
  description = "Enable Azure Managed Grafana"
  type        = bool
  default     = true
}

variable "grafana_name" {
  description = "Name of the Azure Managed Grafana instance"
  type        = string
  default     = ""
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

variable "grafana_api_key_enabled" {
  description = "Enable API key authentication for Grafana"
  type        = bool
  default     = false
}

variable "grafana_deterministic_outbound_ip_enabled" {
  description = "Enable deterministic outbound IP for Grafana"
  type        = bool
  default     = false
}

variable "grafana_major_version" {
  description = "Major version of Grafana to deploy"
  type        = string
  default     = "10"
}

# Common Variables
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
