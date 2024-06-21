variable "cidr_block" {
    type = string
}
variable "enable_dns_support" {
    default = true
}
variable "enable_dns_hostnames" {
    default = true
}
variable "comman_tags" {
    type = map
    default = {}
}
variable "vpc_tags" {
    type = map
    default = {}
}
variable "igw_tags" {
    type = map
    default = {}
}
variable "az" {
    type = list
}
variable "public_cidr_block" {
    type = list
}
variable "public_subnet_names" {
    type = list
}
variable "private_cidr_block" {
    type = list
}
variable "private_subnet_names" {
    type = list
}
variable "database_cidr_block" {
    type = list
}
variable "database_subnet_names" {
    type = list
}
variable "public_route_tags" {
    type = map
    default = {}
}
variable "private_route_tags" {
    type = map
    default = {}
}
variable "database_route_tags" {
    type = map
    default = {}
}
