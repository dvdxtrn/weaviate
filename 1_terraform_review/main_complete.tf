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
# Locals
################################################################################

locals {
  aws_default_tags = merge(
    { "clusterName" = var.eks_cluster_name },
    var.aws_default_tags
  )

  customer_identifier         = trimprefix(var.eks_cluster_name, "wv-")
  customer_cluster_identifier = "prod-dedicated-enterprise"
}

################################################################################
# Kubernetes Namespace
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
# Weaviate Helm Deployment Module
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
