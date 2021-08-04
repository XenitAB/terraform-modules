data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_subnet" "public" {
  filter {
    name = "tag:Name"
    values = [
      "public-0"
    ]
  }
}

resource "aws_security_group" "bastion" {
  name_prefix = "bastion-ssh"
  vpc_id      = data.aws_subnet.public.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.eks_authorized_ips
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  revoke_rules_on_delete = true
}

resource "aws_network_interface" "bastion" {
  subnet_id       = data.aws_subnet.public.id
  security_groups = [aws_security_group.bastion.id]

  tags = {
    Name = "public-0"
  }
}

# Do we rather want to generate the key in tf and store in the paramater
data "aws_ssm_parameter" "bastion_public_key" {
  name = "bastion-public-ssh-key"
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = data.aws_ssm_parameter.bastion_public_key.value
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }

  key_name = aws_key_pair.bastion.key_name

  # Install some needed tools
  user_data = file("${path.module}/file/startup.sh")

}
