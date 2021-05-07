terraform {
  required_version = "~> 0.15"
  required_providers {
    aws = ">= 3.0.0"
  }
}

provider "aws" {
  region = var.region
  profile = "default"
}
