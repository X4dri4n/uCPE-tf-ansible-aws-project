#Provider used by Terraform
provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "ucpe"
}




