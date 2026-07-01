variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_identifier_prefix" {
  description = "Prefix for the DocumentDB cluster identifier"
  type        = string
  default     = "my-docdb-cluster-"
}

variable "instance_identifier_prefix" {
  description = "Prefix for the DocumentDB instance identifier"
  type        = string
  default     = "my-docdb-instance-"
}

variable "master_username" {
  description = "Master username for the DocumentDB cluster"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Instance class for the DocumentDB instance"
  type        = string
  default     = "db.r5.large"
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access DocumentDB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "Production"
}
