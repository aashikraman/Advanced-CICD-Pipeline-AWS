terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAT2IFMO65XQS4CVOP"
  secret_key = "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"
}