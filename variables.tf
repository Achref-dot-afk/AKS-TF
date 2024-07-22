variable "aks_service_principal_app_id" {
  default = ""
}

variable "aks_service_principal_client_secret" {
  default = ""
}

variable "admin_username" {
  default = "demo"
}

variable "cluster_name" {
  default = "demok8s"
}

variable "dns_prefix" {
  default = "demok8s"
}

variable "agent_count" {
  default = 1
}

variable "resource_group_location" {
  default     = "northeurope"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default     = "demo-terraform-kubernetes-RG"
  description = "Resource group name that is unique in your Azure subscription."
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}