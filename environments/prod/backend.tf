terraform {
  backend "s3" {
    bucket         = "duy-mock-project"
    key            = "networking/terraform.tfstate"
    region         = "sa-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

