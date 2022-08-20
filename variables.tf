variable "pawprints" {
  description = "student identifiers"
  type = list
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "virtual_network" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "public_key" {
  type = string
}

variable "private_key" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ansible_path" {
  type = string
}