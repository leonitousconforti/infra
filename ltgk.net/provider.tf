terraform {
  required_providers {
    porkbun = {
      source  = "jianyuan/porkbun"
      version = "0.1.0"
    }
  }
}

variable "porkbun_api_key" {
  sensitive   = true
  description = "The API key for your Porkbun account"
}

variable "porkbun_secret_key" {
  sensitive   = true
  description = "The SECRET key for your Porkbun account"
}

provider "porkbun" {
  api_key    = var.porkbun_api_key
  secret_key = var.porkbun_secret_key
}
