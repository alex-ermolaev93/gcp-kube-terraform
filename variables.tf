variable "region" {
  description = "The region  to host the cluster in"
  type        = string
}

variable "location" {
  description = "The location (region or zone) to host the cluster in"
  type        = string
}

variable "project" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "gcp_auth_file" {
  description = "A reference (self link) to the VPC network to host the cluster in"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the cluster instances"
  type        = string
}

variable "app_name" {
  description = "The name of the cluster"
  type        = string
}

variable "registry_username" {
  description = "The User name for docker hub"
  type        = string
}

variable "registry_password" {
  description = "The password for docker hub"
  type        = string
}

variable "registry_email" {
  description = "The email for docker hub"
  type        = string
}

variable "registry_server" {
  description = "The registry for docker hub"
  type        = string
}

variable "instance_type" {
  description = "The type of the cluster instances"
  type        = string
}