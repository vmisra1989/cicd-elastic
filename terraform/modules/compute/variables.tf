
variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "size" {
  type = string
  default = "Standard_D2s_v3"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "network_interface_ids" {
  type = list(string)
}

variable "disable_password_authentication" {
  type    = bool
  default = true
}

