provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "helloworld" {
  ami                    = "ami-09e67e426f25ce0d7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_security_group" "mysg" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ip" {
  value       = aws_instance.helloworld.public_ip
  description = "The public IP of the web server"
}

