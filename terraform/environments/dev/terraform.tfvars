# Dev Environment Configuration
# Update these values for your environment

environment  = "dev"
location     = "westus2"
project_name = "aks"

# Azure Container Registry name (must be globally unique, alphanumeric only)
# Change this to a unique name for your organization
acr_name = "acraksdevwestus2"

# Kubernetes version (optional, leave null for latest stable)
kubernetes_version = null

# Azure AD Group Object IDs for cluster admin access
# Add your Azure AD group object IDs here for cluster admin access
# You can find these in Azure Portal > Azure Active Directory > Groups
admin_group_object_ids = []

# Tags
tags = {
  Owner       = "platform-team"
  CostCenter  = "IT-Development"
  Application = "microservices-platform"
}
