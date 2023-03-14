terraform {
  backend "s3" {
    bucket = "entana-stage2-infra"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
