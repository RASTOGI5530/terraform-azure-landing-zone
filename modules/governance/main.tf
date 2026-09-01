# ===========================================================
# Governance Module — Azure Policy + Centralized Monitoring
# Creates: Log Analytics Workspace, Policy Assignment (tagging)
# ===========================================================

# ---------------- Log Analytics Workspace ----------------
resource "azurerm_log_analytics_workspace" "landing_zone" {
  name                = "law-landing-zone-demo"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# ---------------- Azure Policy: Enforce Required Tag ----------------
resource "azurerm_resource_group_policy_assignment" "require_environment_tag" {
  name                 = "require-environment-tag"
  resource_group_id   = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99" # Built-in: Require a tag on resource groups

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

data "azurerm_subscription" "current" {}
