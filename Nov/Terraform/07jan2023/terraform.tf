terraform {
  backend "s3" {
    bucket   = "terraform.amaldeep.tech"
    key      = "terraform.tfstate"
    region   = "ap-south-1"
    # endpoint = "https://oss.eu-west-0.prod-cloud-ocb.orange-business.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}