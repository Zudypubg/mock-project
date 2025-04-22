terraform {
  backend "s3" {
    bucket         = "duy-s3-bucket-project"
    key            = "networking/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

