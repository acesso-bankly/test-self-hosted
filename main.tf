data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners = [data.aws_caller_identity.current.account_id]
  filter {
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20200407",
    ]
  }
}

resource "aws_security_group" "security_group" {
  name = "sec_group_github_runner"

  egress {
    from_port   = 0
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ultimate_github_runner" {
  vpc_security_group_ids = [aws_security_group.security_group.id]
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = "t2.micro" ## Free tier
  user_data = templatefile("scripts/ec2.sh", {personal_access_token = var.personal_access_token})
	tags = {
		Name = "GitHub-Runner"	
		Type = "terraform"
	}
}