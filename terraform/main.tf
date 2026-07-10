provider "google" {
  project = var.project_id
  region  = var.region
}

# --------------------------------------------------
# Custom VPC
# --------------------------------------------------
resource "google_compute_network" "vpc_network" {
  name                    = "acme-web-cluster-vpc"
  auto_create_subnetworks = false
}

# --------------------------------------------------
# Private Subnet for GKE
# --------------------------------------------------
resource "google_compute_subnetwork" "gke_subnet" {

  name          = "acme-web-cluster-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"

  # Kubernetes Pods
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  # Kubernetes Services
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

# --------------------------------------------------
# GKE Cluster
# --------------------------------------------------
resource "google_container_cluster" "primary" {

  name     = "acme-web-cluster"
  location = var.region

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  # Stable Kubernetes updates
  release_channel {
    channel = "REGULAR"
  }

  # Enable Cloud Logging
  logging_service = "logging.googleapis.com/kubernetes"

  # Enable Cloud Monitoring
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

# --------------------------------------------------
# Custom Node Pool
# --------------------------------------------------
resource "google_container_node_pool" "primary_nodes" {

  name     = "acme-web-cluster-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name

  node_count = var.node_count

  node_locations = [
    "us-central1-a",
    "us-central1-b"
  ]

  node_config {

    machine_type = var.machine_type

    disk_size_gb = 30
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
