terraform {
 backend "azurerm" {
 }
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}
provider "azurerm" {
    features {
    }
}
resource "azurerm_resource_group" "rg" {
    name = "${var.rg}-${var.env}"
    location = "${var.location}"
  tags = {
    "env" = "${var.env}"
  }
}
resource "azurerm_container_group" "example" {
  name                = "${var.containername}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.env}-{{build.buildid}}"
  os_type             = "Linux"
  image_registry_credential {
    server = "{{ACR-server}}"
    username = "{{ACR-username}}"
    password = "{{ACR-pswd}}"
  }
  container {
    name   = "${var.containername}"
    image  = "satish0910.azurecr.io/sgrthati/tomcatsnakes:{{build.buildId}}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  tags = {
    environment = "${var.env}"
  }
}