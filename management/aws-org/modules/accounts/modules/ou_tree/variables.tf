variable "level_0" {
  description = "Root/Company level to group accounts under."
  type        = list(string)
  default     = ["acme"]
}

variable "level_1" {
  description = "Tier/Stage level to facilitate the demarcation of OU permissions."
  type        = list(string)
  default     = ["prod", "notprod"]
}

variable "level_2" {
  description = "Organizational Unit level. Match to AWS Security Reference Architecture https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/architecture.html"
  type        = list(string)
  default     = ["infrastructure", "security", "workloads"]
}

variable "root_id" {
  description = "Parent Organizational Unit ID or Root ID."
  type        = string
}
