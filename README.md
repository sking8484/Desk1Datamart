# Development
## Initial Setup
### AWS
1. Ensure you have AWS CLI set up and configured.
### Terraform
1. Bootstrap Remote Backend
  + Initialize terraform without backend 
  ```
    terraform {
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "~> 3.0"
        }
      }
    }

    provider "aws" {
      region = "us-east-1"
    }

  ```
