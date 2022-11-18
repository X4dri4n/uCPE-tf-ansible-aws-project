#Backend file for Terraform with tfstate file stored in S3 bucket
terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "eu-central-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "statetfbucket4444"
  }
}
