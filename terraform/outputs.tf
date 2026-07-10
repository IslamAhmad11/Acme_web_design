output "cluster_name" {
  description = "GKE Cluster Name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "vpc_name" {
  description = "VPC Name"
  value       = google_compute_network.vpc_network.name
}
