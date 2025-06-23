terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# The module inherits the AWS provider configuration from the root module.
# You may add aliases here if you need to target multiple AWS accounts/regions.
provider "aws" {}
