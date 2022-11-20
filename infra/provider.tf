terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "caiogomes.me-tf-backend"
    key            = "state/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "caiogomes.me-tf-backend"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "sa-east-1"
}
