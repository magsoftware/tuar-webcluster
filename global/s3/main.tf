provider "aws" {
  region = "eu-central-1"
}


terraform {
  backend "s3" {
    key    = "global/s3/terraform.tfstate"
  }
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "magsoftware-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

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
  name         = "magsoftware-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

