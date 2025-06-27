################################################################################
# Outputs
################################################################################

output "eks_cluster_name" {
  description = "EKS cluster name used by this deployment"
  value       = var.eks_cluster_name
}

output "weaviate_namespace" {
  description = "Kubernetes namespace for Weaviate"
  value       = kubernetes_namespace.weaviate-namespace.metadata[0].name
}

output "weaviate_replica_count" {
  description = "Number of Weaviate replicas deployed"
  value       = var.replica_count
}

output "weaviate_storage_size" {
  description = "Size of the PVC allocated for Weaviate"
  value       = var.weaviate_storage_size
}
