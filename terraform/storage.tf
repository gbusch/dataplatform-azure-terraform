resource "azurerm_storage_account" "storage-account" {
  name                      = "dpgbstorageacdev"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  access_tier               = "Hot"
  account_kind              = "StorageV2"
  is_hns_enabled            = true
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "storage-containter" {
  name                  = "test"
  storage_account_name  = azurerm_storage_account.storage-account.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage" {
  scope                = azurerm_storage_account.storage-account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
