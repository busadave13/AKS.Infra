# TFLint Configuration for AKS Infrastructure
# https://github.com/terraform-linters/tflint

config {
  # Enable module inspection
  call_module_type = "local"
  
  # Force all rules to error level
  force = false
}

# Azure Provider Plugin
plugin "azurerm" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Terraform Language Rules
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# ============================================================
# Naming Convention Rules
# ============================================================
rule "terraform_naming_convention" {
  enabled = true

  # Variable naming: snake_case
  variable {
    format = "snake_case"
  }

  # Output naming: snake_case
  output {
    format = "snake_case"
  }

  # Local naming: snake_case
  locals {
    format = "snake_case"
  }

  # Resource naming: snake_case
  resource {
    format = "snake_case"
  }

  # Data source naming: snake_case
  data {
    format = "snake_case"
  }

  # Module naming: snake_case
  module {
    format = "snake_case"
  }
}

# ============================================================
# Standard Terraform Rules
# ============================================================
rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style   = "flexible"
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

# ============================================================
# Azure-Specific Rules
# ============================================================
# Warn on deprecated Azure resources
rule "azurerm_resource_missing_tags" {
  enabled = false  # We handle tags at module level
}
