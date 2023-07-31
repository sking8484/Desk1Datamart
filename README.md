# Development

## Initial Setup

### AWS

1. Ensure you have AWS CLI set up and configured.

### Terraform

1. Bootstrap Remote Backend

- Initialize terraform without backend in main.tf

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

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${your_bucket_name}"
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

- `terraform init`
- `terraform apply`
- Update main.tf to reflect remote

```
terraform {
  backend "s3" {
    bucket = "${your_bucket_name}"
    key = "tf-infra/terraform.tfstate"
    region = "${your_region}"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
  required_providers {
  .
  .
  .
}
```

- `terraform init`
