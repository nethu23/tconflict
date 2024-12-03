variable "region_name" {}
variable "vpc_cidr_block" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "public_subnet3_cidr" {}
variable "vpc_tag" {}
variable "igw_tag" {}
variable "subnet_tag" {}
variable "rt_cidr_block" {}
variable "rt_tag" {}
variable "ec2_azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "ec2_type" {
  default = {
    web   = "t2.nano"
    db    = "t2.micro"
    cache = "t2.medium"
  }
}
variable "key_name" {}
variable "subnet2_tag" {}
variable "subnet3_tag" {}
variable "env" {}
