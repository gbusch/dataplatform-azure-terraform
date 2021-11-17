# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.11"
    }
  }

  required_version = ">= 0.14.6"
}

provider "azurerm" {
  features {}

  client_id         = var.client_id
  client_secret     = var.client_secret
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "West Europe"
}
