################################################################################
# Providers
################################################################################

# AWS provider with version pinning for stability across deployments
provider "aws" {
  version = "~> 5.0" # Pin version for consistent behavior
  region  = var.region

  default_tags {
    tags = local.aws_default_tags
  }
}

# Kubernetes provider configured for EKS using exec auth
provider "kubernetes" {
  version = "~> 2.30" # Pin version
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1" # Updated to supported API version
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}

# Helm provider using same auth config as Kubernetes provider
provider "helm" {
  version = "~> 2.13" # Pin version
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1" # Unified API version
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    }
  }
}

# Fetch EKS cluster data for Kubernetes and Helm providers
data "aws_eks_cluster" "main" {
  name = var.eks_cluster_name
}

################################################################################
# Local Variables
################################################################################

locals {
  # Merge default AWS tags with cluster name
  aws_default_tags = merge(
    {"clusterName" = var.eks_cluster_name},
    var.aws_default_tags
  )

  # Derive customer identifier by removing prefix
  # This logic assumes all clusters are prefixed with 'wv-' — may need to generalize
  customer_identifier = trimprefix(var.eks_cluster_name, "wv-")

  # If this value will change per environment, convert to a variable
  customer_cluster_identifier = "prod-dedicated-enterprise"
}

################################################################################
# EKS Cluster and VPC Configuration
################################################################################

# (Intentionally omitted for this exercise; assumed provisioned externally)

################################################################################
# Kubernetes Namespace for Weaviate
################################################################################

resource "kubernetes_namespace" "weaviate-namespace" {
  metadata {
    name = var.namespace

    # Optional: Add labels for traceability and protection
    labels = {
      environment = var.environment
      owner       = "sre-team"
    }
  }

  lifecycle {
    prevent_destroy = true # Prevent accidental deletion
  }
}

################################################################################
# High Availability Setup for Weaviate
################################################################################

module "weaviate_helm" {
  source = "./modules/weaviate"

  # Ensure pods are spread across AZs (High Availability)
  replica_count = 3 # Increased from 2 for higher availability

  # Match replication factor with HA expectations
  weaviate_replication_factor = 3 # Updated from 1 to align with replicas

  # Anti-affinity to force pods into different AZs/nodes
  affinity = {
    podAntiAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = [
        {
          labelSelector = {
            matchExpressions = [
              {
                key      = "app"
                operator = "In"
                values   = ["weaviate"]
              }
            ]
          }
          topologyKey = "topology.kubernetes.io/zone" # Ensures pods are spread across zones
        }
      ]
    }
  }

  # Optional tolerations if taints are used in your cluster
  tolerations = [
    {
      key      = "dedicated"
      operator = "Equal"
      value    = "weaviate"
      effect   = "NoSchedule"
    }
  ]

  # Persistent volume claim with configurable storage size
  volume_claim_templates = [
    {
      metadata = {
        name = "weaviate-data"
      }
      spec = {
        accessModes = ["ReadWriteOnce"]
        resources = {
          requests = {
            storage = "50Gi" # Increased from 10Gi; consider making this a variable
          }
        }
      }
    }
  ]

  # Ensures the namespace is created before Helm tries to install into it
  depends_on = [
    kubernetes_namespace.weaviate-namespace
  ]
}

################################################################################
# Additional Modules and Resources
################################################################################

# You may wish to include the following modules based on production needs:
# - ALB Ingress Controller for external access
# - External DNS and Cert Manager for DNS/SSL automation
# - Prometheus/Grafana for observability
# - CloudWatch log groups or FluentBit for log forwarding
