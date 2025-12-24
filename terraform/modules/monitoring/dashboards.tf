# Grafana Dashboard Resources
# Deploys dashboards to Azure Managed Grafana using Azure CLI

#--------------------------------------------------------------
# Locals for Dashboard Configuration
#--------------------------------------------------------------

locals {
  dashboard_files = var.enable_grafana && var.deploy_dashboards ? fileset("${path.module}/dashboards", "*.json") : []

  # Map of dashboard filename to content path
  dashboards = {
    for file in local.dashboard_files :
    file => "${path.module}/dashboards/${file}"
  }
}

#--------------------------------------------------------------
# Dashboard Deployment via Azure CLI
# Uses az grafana dashboard commands to deploy dashboards
#--------------------------------------------------------------

resource "null_resource" "grafana_dashboards" {
  for_each = local.dashboards

  triggers = {
    dashboard_hash = filesha256(each.value)
    grafana_id     = var.enable_grafana ? azurerm_dashboard_grafana.main[0].id : ""
    grafana_name   = var.enable_grafana ? azurerm_dashboard_grafana.main[0].name : ""
  }

  provisioner "local-exec" {
    command = <<-EOT
      az grafana dashboard create \
        --name "${self.triggers.grafana_name}" \
        --resource-group "${var.resource_group_name}" \
        --definition "${each.value}" \
        --overwrite
    EOT
  }

  depends_on = [
    azurerm_dashboard_grafana.main,
    azurerm_role_assignment.grafana_monitoring_reader
  ]
}

#--------------------------------------------------------------
# Output dashboard deployment info
#--------------------------------------------------------------
output "grafana_dashboard_count" {
  description = "Number of dashboards deployed"
  value       = var.enable_grafana && var.deploy_dashboards ? length(local.dashboard_files) : 0
}

output "grafana_dashboard_names" {
  description = "Names of deployed dashboards"
  value       = var.enable_grafana && var.deploy_dashboards ? [for f in local.dashboard_files : trimsuffix(f, ".json")] : []
}
