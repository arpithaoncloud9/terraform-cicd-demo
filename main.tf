provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name
  tags = {
    Environment = "dev"
  }
}