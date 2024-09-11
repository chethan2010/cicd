terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }
  backend"s3"{
    bucket="daws93-dev-bucket"
    key="exp-cicd"
    region="us-east-1"
    dynamodb_table="daws93-locking"   
}
}
provider "aws" {
region="us-east-1"
}