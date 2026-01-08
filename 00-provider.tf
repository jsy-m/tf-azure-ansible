terraform { 
  cloud {    
    organization = "rp-sy" 
    workspaces { 
      name = "tf-azure-ansible" 
    } 
  } 

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  
    aap = {
      source = "ansible/aap"
    }
  }
}

provider "aap" {
  host     = "https://10.65.10.9"
  username = "admin"
  password = var.aap_password
  insecure_skip_verify = true
}

provider "azurerm" {
  features {}

  subscription_id   = "e6f54661-ed1d-4d62-9f60-f33454912e34"
  tenant_id         = "37954b6a-13e5-4c17-8137-5c84015ab986"
  client_id         = "f0730e98-ea0f-48d6-8437-3aa6da1581e7"
  client_secret     = var.azure_client_secret
}
