provider "aws" {
  region = "us-east-1"
  access_key = "AKIA3TE22I7XH4XJBS44"
  secret_key = "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"
  

}


resource "aws_s3_bucket" "first_bucket" {
    bucket = "amaldeeptfbucket"
    tags = {
        Name = "test_bucket"
        Environment = "dev"
        Id = "new"
    }
  
}
