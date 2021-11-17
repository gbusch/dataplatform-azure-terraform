resource "azurerm_data_factory" "factory" {
  name                = var.factory_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  github_configuration {
    account_name    = "gbusch"
    branch_name     = "master"
    git_url         = "https://github.com"
    repository_name = "dataplatform-azure-terraform"
    root_folder     = "factory"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "df-db" {
  scope                = azurerm_databricks_workspace.databricks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.factory.identity[0].principal_id
}
