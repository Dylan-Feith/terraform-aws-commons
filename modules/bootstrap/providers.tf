terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [aws.main_region, aws.secondary_region]
    }
  }
  required_version = ">= 1.1"
}
