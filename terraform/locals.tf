locals {
  prefix = "${var.prefix}-{terraform.workspace}"
  common_tags = {
    "Project Name"         = var.project
    "Environment"          = terraform.workspace
    "Infrastructure owner" = "Subrahmanyam"
    "Contact email"        = "rv.subrahmanyam1@gmail.com"
  }
}