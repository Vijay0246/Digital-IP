# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for terraform-code that provides extra tools for working with multiple terraform-code modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically related variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.azure_account_id
  azure_account_short_id = local.account_vars.locals.azure_account_short_id
  azure_region   = local.region_vars.locals.azure_region
  env_name     = local.environment_vars.locals.environment
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}

  subscription_id = "c19f8a6a-ffd8-4b8e-98f6-047e49e59622"
  client_id       = "769bf2b6-ef13-4d20-8299-ae426468b5d5"
  client_secret   = "6v-KSNOTg4e4AeeK_5SD22j-Z2PeV-D2C2"
  tenant_id       = "2b6c600f-b6cb-4329-af3b-1b32c62c440f"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "Mamatha-poc"
    storage_account_name = "storageaccountmamatb488"
    container_name       = "terragruntbackned" 
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)