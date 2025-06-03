terraform {
  required_providers {
    porkbun = {
      source  = "jianyuan/porkbun"
      version = "0.1.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://sfo3.digitaloceanspaces.com"
    }

    bucket = "ltgk-terraform"
    key    = "ltgk.net/terraform.tfstate"

    # Deactivate a few AWS-specific checks
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
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
