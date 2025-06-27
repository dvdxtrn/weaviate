output "weaviate_release_status" {
  description = "The status of the Helm release"
  value       = helm_release.weaviate.status
}

output "weaviate_release_name" {
  description = "The name of the Helm release"
  value       = helm_release.weaviate.name
}
