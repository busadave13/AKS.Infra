# AKS Module - Azure Kubernetes Service Cluster with GitOps

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  # System Node Pool (default)
  default_node_pool {
    name                         = var.system_node_pool_name
    vm_size                      = var.system_node_pool_vm_size
    node_count                   = var.system_node_pool_node_count
    os_disk_size_gb              = var.system_node_pool_os_disk_size_gb
    vnet_subnet_id               = var.vnet_subnet_id
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "systemtemp"

    upgrade_settings {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
  }

  # Managed Identity
  identity {
    type = var.identity_type
  }

  # Azure AD Integration with Azure RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.azure_rbac_enabled
    admin_group_object_ids = var.admin_group_object_ids
  }

  # Network Configuration - Azure CNI Overlay
  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"
  }

  # Container Insights
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  # Prometheus Metrics (Azure Managed Prometheus)
  dynamic "monitor_metrics" {
    for_each = var.prometheus_enabled ? [1] : []
    content {
      annotations_allowed = null
      labels_allowed      = null
    }
  }

  # Auto-upgrade channel
  automatic_upgrade_channel = "patch"

  # Maintenance window (weekends)
  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = [0, 1, 2, 3, 4, 5]
    }
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2, 3, 4, 5]
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      kubernetes_version, # Managed by auto-upgrade
    ]
  }
}

# User Node Pool with Spot Instances
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = var.user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.user_node_pool_vm_size
  os_disk_size_gb       = var.user_node_pool_os_disk_size_gb
  vnet_subnet_id        = var.vnet_subnet_id

  # Autoscaling
  auto_scaling_enabled = true
  min_count            = var.user_node_pool_min_count
  max_count            = var.user_node_pool_max_count

  # Spot Instance Configuration (if enabled)
  priority        = var.user_node_pool_spot_enabled ? "Spot" : "Regular"
  eviction_policy = var.user_node_pool_spot_enabled ? "Delete" : null
  spot_max_price  = var.user_node_pool_spot_enabled ? -1 : null # -1 means pay up to on-demand price

  # Node labels
  node_labels = {
    "nodepool" = var.user_node_pool_name
    "priority" = var.user_node_pool_spot_enabled ? "spot" : "regular"
  }

  # Taints for spot nodes (automatically applied by Azure for spot nodes)
  node_taints = var.user_node_pool_spot_enabled ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"] : []

  upgrade_settings {
    max_surge                     = "10%"
    drain_timeout_in_minutes      = 0
    node_soak_duration_in_minutes = 0
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      node_count, # Managed by autoscaler
    ]
  }
}

# ACR Pull Role Assignment - Allow AKS to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

# GitOps (Flux) Extension
resource "azurerm_kubernetes_cluster_extension" "flux" {
  count = var.gitops_enabled ? 1 : 0

  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.main.id
  extension_type = "microsoft.flux"

  configuration_settings = {
    "helm-controller.enabled"             = "true"
    "source-controller.enabled"           = "true"
    "kustomize-controller.enabled"        = "true"
    "notification-controller.enabled"     = "true"
    "image-automation-controller.enabled" = "false"
    "image-reflector-controller.enabled"  = "false"
  }
}

# Data Collection Rule Association for Prometheus Metrics
resource "azurerm_monitor_data_collection_rule_association" "prometheus" {
  count = var.prometheus_enabled && var.data_collection_rule_id != null ? 1 : 0

  name                    = "prometheus-dcra-${var.cluster_name}"
  target_resource_id      = azurerm_kubernetes_cluster.main.id
  data_collection_rule_id = var.data_collection_rule_id
  description             = "Association of data collection rule for Prometheus metrics from AKS cluster ${var.cluster_name}"
}
