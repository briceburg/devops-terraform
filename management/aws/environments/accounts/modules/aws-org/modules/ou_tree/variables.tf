variable "level_0" {
  type = list(string)
}

variable "level_1" {
  type = list(string)
}

variable "level_2" {
  type    = list(string)
  default = []
}

variable "parent_id" {
  description = "Parent Organizational Unit or Root ID"
  type        = string
}
