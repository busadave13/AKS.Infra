# AKS Module Variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = null # Will use latest stable if not specified
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
}

variable "sku_tier" {
  description = "SKU tier for AKS (Free or Standard)"
  type        = string
  default     = "Free"
}

# Network Configuration
variable "vnet_subnet_id" {
  description = "ID of the subnet for the AKS nodes"
  type        = string
}

variable "network_plugin" {
  description = "Network plugin for the cluster (azure, kubenet)"
  type        = string
  default     = "azure"
}

variable "network_plugin_mode" {
  description = "Network plugin mode (overlay for Azure CNI Overlay)"
  type        = string
  default     = "overlay"
}

variable "network_policy" {
  description = "Network policy provider (azure, calico)"
  type        = string
  default     = "azure"
}

variable "pod_cidr" {
  description = "CIDR for pod network (used with CNI Overlay)"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.0.0.10"
}

# System Node Pool
variable "system_node_pool_name" {
  description = "Name of the system node pool"
  type        = string
  default     = "system"
}

variable "system_node_pool_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_B2ms"
}

variable "system_node_pool_node_count" {
  description = "Number of nodes in system node pool"
  type        = number
  default     = 1
}

variable "system_node_pool_os_disk_size_gb" {
  description = "OS disk size for system nodes"
  type        = number
  default     = 30
}

# User Node Pool
variable "user_node_pool_name" {
  description = "Name of the user node pool"
  type        = string
  default     = "user"
}

variable "user_node_pool_vm_size" {
  description = "VM size for user node pool"
  type        = string
  default     = "Standard_B2ms"
}

variable "user_node_pool_min_count" {
  description = "Minimum number of nodes in user node pool"
  type        = number
  default     = 1
}

variable "user_node_pool_max_count" {
  description = "Maximum number of nodes in user node pool"
  type        = number
  default     = 2
}

variable "user_node_pool_os_disk_size_gb" {
  description = "OS disk size for user nodes"
  type        = number
  default     = 30
}

variable "user_node_pool_spot_enabled" {
  description = "Enable spot instances for user node pool"
  type        = bool
  default     = true
}

# Identity
variable "identity_type" {
  description = "Type of identity for the cluster"
  type        = string
  default     = "SystemAssigned"
}

# Azure AD Integration
variable "azure_rbac_enabled" {
  description = "Enable Azure RBAC for Kubernetes authorization"
  type        = bool
  default     = true
}

variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs for cluster admin access"
  type        = list(string)
  default     = []
}

# Monitoring
variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace for Container Insights"
  type        = string
}

# Prometheus Monitoring
variable "prometheus_enabled" {
  description = "Enable Azure Managed Prometheus metrics collection"
  type        = bool
  default     = false
}

variable "data_collection_rule_id" {
  description = "ID of the data collection rule for Prometheus metrics"
  type        = string
  default     = null
}

# ACR Integration
variable "acr_id" {
  description = "ID of the Azure Container Registry to attach"
  type        = string
}

# GitOps (Flux) Configuration
variable "gitops_enabled" {
  description = "Enable GitOps (Flux) add-on"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
