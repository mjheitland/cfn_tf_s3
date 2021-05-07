#--- 0_tfstate/config.tf ---

terraform {
  required_version = "~> 0.15"
  required_providers {
    aws = ">= 3.0.0"
  }
#  backend "s3" {
#    key = "0_tfstate.tfstate"
#  }
}

provider "aws" {
  region = var.region
  profile = "default"
}
