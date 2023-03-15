variable "webserver_name" {
  type = string
}
variable "aws_instance_type" {
  type = string
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "Virtual Private Cloud Name"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.10.0/24"
}

variable "subnet_name" {
  type    = string
  default = "Subnet"
}

variable "igw_name" {
  type    = string
  default = "Internet Gateway"
}

variable "ec2_name" {
  type    = string
  default = "Instance Name"
}