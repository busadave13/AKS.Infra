# Terraform Backend Configuration
# 
# Before using this backend, you need to create the storage account:
#
# az group create --name rg-terraform-state --location westus2
# az storage account create --name stterraformstate<unique> --resource-group rg-terraform-state --sku Standard_LRS --encryption-services blob
# az storage container create --name tfstate --account-name stterraformstate<unique>
#
# Then update the storage_account_name below with your actual storage account name
# and uncomment the backend block.

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-terraform-state"
#     storage_account_name = "stterraformstate<unique>"
#     container_name       = "tfstate"
#     key                  = "aks-dev.terraform.tfstate"
#   }
# }

# For local development, Terraform will use local state by default.
# Uncomment the backend block above when ready for team collaboration.
