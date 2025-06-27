################################################################################
# Input Variables for Weaviate Helm Chart Deployment
################################################################################

variable "namespace" {
  description = "Kubernetes namespace to deploy Weaviate into"
  type        = string
}

variable "replica_count" {
  description = "Number of Weaviate pods"
  type        = number
}

variable "weaviate_replication_factor" {
  description = "Weaviate's internal data replication setting"
  type        = number
}

variable "affinity" {
  description = "Pod anti/affinity settings"
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Node tolerations"
  type        = list(any)
  default     = []
}

variable "volume_claim_templates" {
  description = "PVC templates for Weaviate data"
  type        = list(any)
}

# Helm Chart Settings
variable "chart_name" {
  description = "Helm chart name for Weaviate"
  type        = string
  default     = "weaviate"
}

variable "chart_repo" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://weaviate.github.io/weaviate-helm"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "0.2.9" # Update as needed
}
