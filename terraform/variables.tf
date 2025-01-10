# Environment Name
variable "ENV" {
  type        = string
  description = "The prefix for all resources in this environment. Make it unique, e.g., 'sparksql'."
}

# Azure Region
variable "LOCATION" {
  type        = string
  description = "The Azure region where resources will be created."
  default     = "northeurope" # Updated default region
}

variable "PREVENT_DESTROY" {
  type        = bool
  description = "Toggle to enable/disable prevent_destroy lifecycle rule."
  default     = true
}


# BDCC Region for Billing
variable "BDCC_REGION" {
  type        = string
  description = "The BDCC region identifier for billing purposes."
  default     = "global" # Default remains as global
}

# Storage Account Replication Type
variable "STORAGE_ACCOUNT_REPLICATION_TYPE" {
  type        = string
  description = "Specifies the replication type for the Azure Storage Account."
  default     = "LRS" # Default replication type is locally redundant storage
}

# IP Rules for Network Access
variable "IP_RULES" {
  type        = map(string)
  description = "A map of IP addresses permitted to access the storage account."
  default = {
    "epam-vpn-ru-0" = "185.44.13.36"  # Russia VPN
    "epam-vpn-eu-0" = "195.56.119.209" # Europe VPN
    "epam-vpn-by-0" = "213.184.231.20" # Belarus VPN 1
    "epam-vpn-by-1" = "86.57.255.94"   # Belarus VPN 2
  }
}
