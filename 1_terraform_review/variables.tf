################################################################################
# Input Variables
################################################################################

variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for Weaviate resources"
  type        = string
  default     = "weaviate"
}

variable "environment" {
  description = "Environment label (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "aws_default_tags" {
  description = "Default tags to apply to AWS resources"
  type        = map(string)
  default     = {}
}

# Optional customizations for Helm deployment

variable "replica_count" {
  description = "Number of Weaviate replicas to deploy"
  type        = number
  default     = 3
  validation {
    condition     = var.replica_count >= 1
    error_message = "replica_count must be at least 1."
  }
}

variable "weaviate_replication_factor" {
  description = "Weaviate replication factor"
  type        = number
  default     = 3
  validation {
    condition     = var.weaviate_replication_factor >= 1
    error_message = "Replication factor must be at least 1."
  }
}

variable "weaviate_storage_size" {
  description = "Persistent storage size for Weaviate data volume"
  type        = string
  default     = "50Gi"
}

