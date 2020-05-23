provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "An example of a number variable in Terraform"
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "the public IP address of the web server"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  # here we specify which security group to use, which creates an implicit dependency
  vpc_security_group_ids = [aws_security_group.instance.id]

  # user data is a good way to run a script
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  # giving the ec2 a name  
  tags = {
    Name = "terraform-example"
  }
}

# by deafult ec2 doesn't allow any traffic incoming or outgoing
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
