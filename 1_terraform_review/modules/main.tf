resource "helm_release" "weaviate" {
  name       = "weaviate"
  namespace  = var.namespace
  chart      = var.chart_name
  repository = var.chart_repo
  version    = var.chart_version
  create_namespace = false

  values = [
    yamlencode({
      replicaCount = var.replica_count

      affinity     = var.affinity
      tolerations  = var.tolerations

      weaviate = {
        replicationFactor = var.weaviate_replication_factor
      }

      persistence = {
        enabled = true
        existingClaim = null
        size = var.volume_claim_templates[0].spec.resources.requests.storage
        accessMode = var.volume_claim_templates[0].spec.accessModes[0]
      }
    })
  ]
}
