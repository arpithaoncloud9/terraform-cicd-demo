provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "bucket_b" {
  bucket = "maria-import-demo-2026"
}

resource "aws_s3_bucket_versioning" "bucket_b_versioning" {
  bucket = aws_s3_bucket.bucket_b.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "bucket_c" {
  bucket = "maria-import-demo-2027"
}
