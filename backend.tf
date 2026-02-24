terraform {
  backend "s3" {
    bucket         = "maria-terraform-state-2026"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
