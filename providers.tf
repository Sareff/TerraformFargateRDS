provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

provider "aws" {
  alias  = "us_east_1_waf"
  region = "us-east-1"
}