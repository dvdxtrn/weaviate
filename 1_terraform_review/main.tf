################################################################################
# Providers
################################################################################

provider "aws" {
  version = "~> 5.0"
  region  = var.region

  default_tags {
    tags = local.aws_default_tags
  }
}

provider "kubernetes" {
  version = "~> 2.30"
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}

provider "helm" {
  version = "~> 2.13"
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    }
  }
}

data "aws_eks_cluster" "main" {
  name = var.eks_cluster_name
}

################################################################################
# Local Variables
################################################################################

locals {
  aws_default_tags = merge(
    { "clusterName" = var.eks_cluster_name },
    var.aws_default_tags
  )

  customer_identifier         = regex("^wv-(.*)$", var.eks_cluster_name) != null ? regex("^wv-(.*)$", var.eks_cluster_name)[0] : var.eks_cluster_name
  customer_cluster_identifier = "prod-dedicated-enterprise"
}

################################################################################
# EKS Cluster and VPC Configuration
################################################################################

# (Intentionally omitted for this exercise;)
# This section would typically define:
#  - A VPC with public/private subnets
#  - An EKS cluster and node group
#  - IAM roles for Kubernetes control
#  - NAT gateway and routing
#
# To add these resources, you can use the official AWS VPC Terraform module:
#   https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# Example:
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   name    = var.vpc_name
#   cidr    = var.vpc_cidr
#   ... (other required variables)
# }

# To add these resources, you can use the official AWS EKS Terraform module:
#   https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
# Example:
# module "eks" {
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = var.eks_cluster_name
#   ... (other required variables)
# }

################################################################################
# Kubernetes Namespace for Weaviate
################################################################################

resource "kubernetes_namespace" "weaviate-namespace" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
      owner       = "sre-team"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

################################################################################
# High Availability Setup for Weaviate
################################################################################

module "weaviate_helm" {
  source = "./modules/weaviate"

  replica_count               = var.replica_count
  weaviate_replication_factor = var.weaviate_replication_factor

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
          topologyKey = "topology.kubernetes.io/zone"
        }
      ]
    }
  }

  tolerations = [
    {
      key      = "dedicated"
      operator = "Equal"
      value    = "weaviate"
      effect   = "NoSchedule"
    }
  ]

  volume_claim_templates = [
    {
      metadata = {
        name = "weaviate-data"
      }
      spec = {
        accessModes = ["ReadWriteOnce"]
        resources = {
          requests = {
            storage = var.weaviate_storage_size
          }
        }
      }
    }
  ]

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