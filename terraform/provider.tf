

provider "aws" {
  
}

terraform {
  backend "s3" {
    bucket = "tf-ressources-gha"
    region = "eu-west-3"
    key = "github-actions/terraform.tfstate"
    encrypt = true
    dynamodb_table = "tf-ressources-gha-lock"
  }
}