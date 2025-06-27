# AWS Region
region = "us-west-2"

# Name of your existing EKS cluster
eks_cluster_name = "wv-customer-prod"

# Kubernetes namespace where Weaviate will be deployed
namespace = "weaviate"

# Environment label used for tagging and namespace labeling
environment = "prod"

# Optional: Default AWS tags to apply to all resources
aws_default_tags = {
  owner       = "sre-team"
  environment = "prod"
  project     = "weaviate-cluster"
}

# Weaviate pod replica count for High Availability
replica_count = 3

# Internal data replication factor used by Weaviate
weaviate_replication_factor = 3

# Persistent storage volume per pod (make sure node types support this)
weaviate_storage_size = "50Gi"
