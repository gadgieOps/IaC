resource "aws_s3_bucket" "tfstate" {
  bucket = "gadgieops-yem-tfstate"

  tags = {
    env = "gadgieops.yem"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tfstate-versioning" {
  bucket = aws_s3_bucket.tfstate.id
  
  versioning_configuration {
    status = "Enabled"
  }
}
