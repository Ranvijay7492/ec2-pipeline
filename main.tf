resource "aws_security_group" "allow_ssh" {
   name        = "allow_ssh"
   description = "Allow SSH inbound traffic"
   vpc_id      = aws_vpc.ranvijay-vpc.id

   ingress {
     description = "SSH Inbound"
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
     description = "Internet"
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
   tags = merge({
     Name = "Bastion",
   })
}

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

resource "aws_instance" "ranvijayTF" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
#  availability_zone           = var.az_bastion
  key_name                    = var.key_name
  subnet_id                   = var.public_subnets
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted   = true
    volume_size = 50
    tags = merge({
      Name = "ranvijayTF-EBS",
    })
  }
  tags = merge({
    Name = "ranvijayTF",
  })
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip" "ranvijayTF_eip" {
  instance = aws_instance.ranvijayTF.id
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ranvijayTF.id
  allocation_id = aws_eip.ranvijayTF_eip.id
}
