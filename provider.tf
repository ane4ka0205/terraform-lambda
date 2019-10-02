terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = ">=1.11"
  region  = "${var.region}"
}
