variable "resource_group_name" {
  default = "dp-gb-dev"
}

variable "factory_name" {
  default = "dp-gb-factory-dev"
}

variable "databricks_name" {
  default = "dp-gb-databricks-dev"
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}