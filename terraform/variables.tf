

variable "ec2_instance_type" {
  default = "t2.medium"
}

variable "ec2_root_vol" {
  description = "SSH key pair name"
  default = 29
  type = number
}

variable "ec2_ami_id" {
  description = "AMI ID for Ubuntu 22.04"
  default = "ami-0f918f7e67a3323f0"
  type = string
}


