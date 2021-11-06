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

variable "database_user" {
  type        = string
  description = "Database User"
}

variable "database_password" {
  type        = string
  description = "Database Password"
}

variable "project_name" {
  type        = string
  description = "Expy"
}

variable "workspace_env" {
  type        = string
  description = "Workspace environment"
}

variable "github_user" {
  type        = string
  description = "Name of the Github user"
}

variable "github_repo" {
  type        = string
  description = "Expy repo"
}
