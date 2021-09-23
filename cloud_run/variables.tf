variable "project_id" {
  type        = string
  description = "Unique project identifier"
}

variable "location_id" {
  type        = string
  description = "Region containing assets"
}

variable "zone_id" {
  type        = string
  description = "Zone within region"
}

variable "org_name" {
  type        = string
  description = "Google cloud organization name"
}

variable "workspace_id" {
  type        = string
  description = "Terraform workspace name"
}

variable "database_user" {
  type        = string
  description = "Terraform workspace name"
}

variable "database_password" {
  type        = string
  description = "Terraform workspace name"
}

