variable "name" {
  default = "Ranvijay-VPC"
  type        = string
}
variable "vpc_cidr" {
  default = "101.0.0.0/16"
  type        = string

}
variable "public_subnets" {
  type        = string
  description = "list of public subnet addresses"
  default     = "101.0.0.0/24"
}
variable "key_name" {
  type        = string
  default     = "ranvijayTF-keypair"
}