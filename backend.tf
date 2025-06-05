terraform {
  backend "s3" {
    bucket = "hcltechtrainings"
    key    = "2tier/terraform.tfstate"
    region = "ap-south-1"
  }
}