terraform {
  backend "s3" {
    bucket         = "vpc-peering-backend-01"
    key            = "backend/vpc-peering-backend-01.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend-01"
  }
}
