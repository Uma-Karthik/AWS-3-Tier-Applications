terraform {
  backend "s3" {
    bucket = "uma-terraform-state-8997"
    key    = "aws-3-tier/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}