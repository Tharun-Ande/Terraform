variable "vpc_cidr" {
    description = "vpc-cidr-block"
    type = string
}

variable "vpc_tenancy" {
    description = "vpc-tenancy"
    type =  string
}

variable "vpc_tag" {
    description = "vpc_tag_name"
    type = string
}

variable "subnet_cidr_block" {
    description = "subnet_cidr_block"
    type = string
}

variable "subnet_tag" {
    description = "subnet_tag"
    type = string
}

variable "subnet_cidr_block_pvt" {
    description = "subnet_cidr_block_pvt"
    type = string
}

variable "subnet_tag_pvt" {
    description = "subnet_tag_pvt"
    type = string
}


g
variable "igw_tag" {
    description = "igw_tag"
    type = string
}

variable "pb_rt_cidr_blk" {
    description = "pb_rt_cidr_blk"
    type = string
}

variable "pb_rt_tag" {
  description = "pb_rt_tag"
  type = string
}

variable "pvt_rt_cidr_blk" {
  description = "pvt_rt_cidr_blk"
  type = string
}

variable "pvt_rt_tag" {
  description = "pvt_rt_tag"
  type = string
}

variable "eip_tag" {
  description = "eip_tag"
  type = string
}

variable "n_gw" {
  description = "n-gw"
  type = string
}

variable "key" {
  description = "key"
  type = string
}

variable "p_key" {
  description = "p-key"
  type = string
}

variable "sg" {
  description = "sg"
  type = string
}

variable "sg_tag" {
  description = "sg_tag"
  type = string
}

variable "ami" {
  description = "ami"
  type = string
}

variable "key_in" {
  description = "key_in"
  type = string
}

variable "n_pub_tag" {
  description = "n_pub_tag"
  type = string
}

variable "ami_pvt" {
  description = "ami_pvt"
  type = string
}

variable "n_pvt_tag" {
  description = "n_pvt_tag"
  type = string
}

variable "x" {
  description = "true"
  type = bool
}

variable "y" {
  description = "false"
  type = bool
}

variable "i" {
    description = "i"
    type = string
}