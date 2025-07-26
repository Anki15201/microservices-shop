
resource "aws_key_pair" "deployer" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_instance" "k8s_control_plane" {
  ami           = var.ec2_ami_id # Amazon Linux 2 AMI
  instance_type = var.ec2_instance_type
  count         = 1
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.k8s_sg.name]
  tags = {
    Name = "k8s-control-plane"
  }

  root_block_device {
    volume_size           = var.ec2_root_vol        # Increase to 20 GB
    volume_type           = "gp3"       # General-purpose SSD
    delete_on_termination = true        # Delete volume when instance terminates
    encrypted             = true        # Enable encryption
  }

}

resource "aws_instance" "k8s_worker" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  count         = 2
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.k8s_sg.name]
  tags = {
    Name = "k8s-worker-${count.index}"
  }

  root_block_device {
    volume_size           = var.ec2_root_vol          # Increase to 20 GB
    volume_type           = "gp3"       # General-purpose SSD
    delete_on_termination = true        # Delete volume when instance terminates
    encrypted             = true        # Enable encryption
  } 
}

resource "aws_security_group" "k8s_sg" {
  name = "k8s-security-group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  ingress {
    from_port   = 80
    to_port     = 80 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http open"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-security-group"
  }
}



