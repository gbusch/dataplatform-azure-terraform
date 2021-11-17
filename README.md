# dataplatform-azure-terraform


## Azure register application
* Show accounts: `az account list`
* Change accounts: `az account set --subscription="SUBSCRIPTION_ID"`
* Go to databricks workspace and add service principal as Contributor


## Getting started with Terraform

* Login in to Azure with `az login`
* `terraform init`(make sure Terraform is up-to-date)
* Formatting: `terraform fmt`, validation: `terraform validate`
* Plan with `terraform plan` (terraform shows what it would do)
* Apply code with `terraform apply`
* 