terraform {
  backend "azurerm" {
      resource_group_name  = "customRG"
      storage_account_name = "tfstateaccs"
      container_name       = "blobcontainer"
      key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.84.0"
    }
  }
  required_version = ">= 1.1.3"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

# resource "random_id" "log_analytics_workspace_name_suffix" {
#   byte_length = 8
# }

# resource "azurerm_log_analytics_workspace" "test" {
#   location            = var.log_analytics_workspace_location
#   # The WorkSpace name has to be unique across the whole of azure;
#   # not just the current subscription/tenant.
#   name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = var.log_analytics_workspace_sku
# }

# resource "azurerm_log_analytics_solution" "test" {
#   location              = azurerm_log_analytics_workspace.test.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   solution_name         = "ContainerInsights"
#   workspace_name        = azurerm_log_analytics_workspace.test.name
#   workspace_resource_id = azurerm_log_analytics_workspace.test.id

#   plan {
#     product   = "OMSGallery/ContainerInsights"
#     publisher = "Microsoft"
#   }
# }

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }
}