provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "github.com/BijanJohn/terraform-modules//modules/services/webserver-cluster?ref=v0.0.2"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "bijan-terraform-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port         = 12345
  protocol          = "tcp"
  security_group_id = module.webserver_cluster.alb_security_group_id
  to_port           = 12345
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}