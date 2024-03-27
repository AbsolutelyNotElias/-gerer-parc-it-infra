terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "random_integer" "random_suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "example" {
  name     = "rg-idriss-saidou-${random_integer.random_suffix.result}"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "asp-idriss-saidou-${random_integer.random_suffix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "example" {
  name                = "webapp-idriss-saidou-${random_integer.random_suffix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  site_config {
    app_settings = {
      "WEBSITE_JAVA_VERSION" = "17"
      "WEBSITE_RESOURCE_GROUP" = azurerm_resource_group.example.name
    }

    app_command_line = ""
    java_version     = "17"
  }
}
