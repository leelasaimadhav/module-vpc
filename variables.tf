variable "vpc_cidr" {
  type = string
  description = "CIDR Range for VPC"
}


variable "list_of_public_subnet_az" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "List of Public Subnet Availability Zones"
}

variable "list_of_public_subnet_cidr" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.5.0/24", "10.0.7.0/24"]
  description = "List of Public subnet CIDR"

}


variable "list_of_private_subnet_az" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
  description = "List of Public Subnet Availability Zones"
}

variable "list_of_private_subnet_cidr" {
  type = list(string)
  default = ["10.0.10.0/24", "10.0.15.0/24"]
  description = "List of Public subnet CIDR"
}