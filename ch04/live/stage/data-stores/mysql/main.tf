provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "bijan-terraform-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "bijan-terraform-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  instance_class      = "db.t2.micro"
  identifier_prefix   = "bijan-terraform-example"
  engine              = "mysql"
  allocated_storage   = 10
  name                = var.db_name
  username            = "admin"
  skip_final_snapshot = true
  password            = var.db_password
  # This stores the password in AWS Secrets Manager
  #password =
  #  data.aws_secretsmanager_secret_version.db_password.secret_string
}

# This is one way to store the password
#data "aws_secretsmanager_secret_version" "db_password" {
#  secret_id = "mysql-master-password-stage"
#}