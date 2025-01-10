# Setup azurerm as a state backend
terraform {
  backend "azurerm" {
    resource_group_name   = "rg-sparksql-northeurope"  # Storage Account'ın bulunduğu Resource Group
    storage_account_name  = "sparksqlterraform"         # Storage Account adı
    container_name        = "terraformstate"            # Container adı
    key                    = "terraform.tfstate"        # State dosyasının adı
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Azure Client Configuration
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "bdcc" {
  name     = "rg-${var.ENV}-${var.LOCATION}"
  location = var.LOCATION

 

  tags = {
    region = var.BDCC_REGION
    env    = var.ENV
  }
}

# Storage Account
resource "azurerm_storage_account" "bdcc" {
  name                     = "st${var.ENV}${var.LOCATION}"
  resource_group_name      = azurerm_resource_group.bdcc.name
  location                 = azurerm_resource_group.bdcc.location
  account_tier             = "Standard"
  account_replication_type = var.STORAGE_ACCOUNT_REPLICATION_TYPE
  is_hns_enabled           = true

  network_rules {
    default_action = "Allow"
    ip_rules       = values(var.IP_RULES)
  }



  tags = {
    region = var.BDCC_REGION
    env    = var.ENV
  }
}

# Storage Data Lake Gen2 Filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "gen2_data" {
  name               = "data"
  storage_account_id = azurerm_storage_account.bdcc.id

 
}

# Databricks Workspace
resource "azurerm_databricks_workspace" "bdcc" {
  name                = "dbw-${var.ENV}-${var.LOCATION}"
  resource_group_name = azurerm_resource_group.bdcc.name
  location            = azurerm_resource_group.bdcc.location
  sku                 = "standard"

  tags = {
    region = var.BDCC_REGION
    env    = var.ENV
  }
}
