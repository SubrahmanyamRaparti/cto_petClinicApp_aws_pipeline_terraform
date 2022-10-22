variable "aws_region" {}

variable "prefix" {
  description = "project prefix"
  default     = "pet-clinic-app"
  type        = string
}

variable "project" {
  description = "Name of the project"
  default     = "Pet Clinic Java Application"
  type        = string
}