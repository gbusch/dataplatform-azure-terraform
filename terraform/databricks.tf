resource "azurerm_databricks_workspace" "databricks" {
  name                = var.databricks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "standard"
}

provider "databricks" {
  host                 = azurerm_databricks_workspace.databricks.workspace_url

  azure_client_id         = var.client_id
  azure_client_secret     = var.client_secret
  azure_tenant_id         = var.tenant_id
}

resource "databricks_cluster" "cluster" {
  cluster_name            = "terraform"
  idempotency_token       = "terraform"
  spark_version           = "9.1.x-scala2.12"
  driver_node_type_id     = "Standard_DS3_v2"
  node_type_id            = "Standard_DS3_v2"
  num_workers             = 1
  autotermination_minutes = 10
  spark_env_vars = {
      PYSPARK_PYTHON = "/databricks/python3/bin/python3"
    }
  spark_conf = {
    "spark.databricks.repl.allowedLanguages":"python,sql",
    "spark.databricks.passthrough.enabled": "true"
  }
}

resource "databricks_secret_scope" "terraform" {
    name                     = "application"
    initial_manage_principal = "users"
}

resource "databricks_secret" "service_principal_key" {
    key          = "service_principal_key"
    string_value = var.client_secret
    scope        = databricks_secret_scope.terraform.name
}

resource "databricks_mount" "passthrough" {
  name = "passthrough-test"
  cluster_id = databricks_cluster.cluster.id

  uri = "abfss://${azurerm_storage_container.storage-containter.name}@${azurerm_storage_account.storage-account.name}.dfs.core.windows.net"
  extra_configs = {
    "fs.azure.account.auth.type":                          "OAuth",
    "fs.azure.account.oauth.provider.type":                "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id":                   var.client_id,
    "fs.azure.account.oauth2.client.secret":               "{{secrets/${databricks_secret_scope.terraform.name}/${databricks_secret.service_principal_key.key}}}",
    "fs.azure.account.oauth2.client.endpoint":             "https://login.microsoftonline.com/${var.tenant_id}/oauth2/token",
    "fs.azure.createRemoteFileSystemDuringInitialization": "false",
  }
}