# TFLint Configuration for AKS.Infrastructure
# https://github.com/terraform-linters/tflint

config {
  # Enable module inspection
  call_module_type = "local"
  
  # Force all rules to fail on error
  force = false
}

# Azure Provider Plugin
# https://github.com/terraform-linters/tflint-ruleset-azurerm
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
# Custom Rule Configuration
# ============================================================

# Naming Convention Rules
rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
  
  # Custom naming for specific block types
  custom_formats = {
    # Variables should be snake_case
    variable = {
      format = "snake_case"
    }
    # Outputs should be snake_case  
    output = {
      format = "snake_case"
    }
    # Resources should be snake_case
    resource = {
      format = "snake_case"
    }
    # Data sources should be snake_case
    data = {
      format = "snake_case"
    }
    # Modules should be snake_case
    module = {
      format = "snake_case"
    }
    # Locals should be snake_case
    locals = {
      format = "snake_case"
    }
  }
}

# Require descriptions for variables
rule "terraform_documented_variables" {
  enabled = true
}

# Require descriptions for outputs
rule "terraform_documented_outputs" {
  enabled = true
}

# Require type declarations for variables
rule "terraform_typed_variables" {
  enabled = true
}

# Disallow deprecated syntax
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Disallow legacy index syntax
rule "terraform_deprecated_index" {
  enabled = true
}

# Require terraform block to specify version constraints
rule "terraform_required_version" {
  enabled = true
}

# Require provider version constraints
rule "terraform_required_providers" {
  enabled = true
}

# Standard module structure
rule "terraform_standard_module_structure" {
  enabled = true
}

# Disallow empty list items
rule "terraform_empty_list_equality" {
  enabled = true
}

# Enforce consistent expression style
rule "terraform_unused_declarations" {
  enabled = true
}

# Warn about unused required providers
rule "terraform_unused_required_providers" {
  enabled = true
}

# ============================================================
# Azure-Specific Rules (from azurerm plugin)
# ============================================================
# The azurerm plugin automatically enables rules for:
# - Invalid VM sizes
# - Invalid locations
# - Deprecated resources
# - Invalid resource references
