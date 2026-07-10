provider "google" {
  project = var.project_id
  region  = var.region
}

# ---------------------------------------
# Custom VPC
# ---------------------------------------
resource "google_compute_network" "vpc_network" {
  name                    = "acme-web-cluster-vpc"
  auto_create_subnetworks = false
}

# ---------------------------------------
# Custom Subnet
# ---------------------------------------
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "acme-web-cluster-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

# ---------------------------------------
# GKE Cluster
# ---------------------------------------
resource "google_container_cluster" "primary" {

  name = "acme-web-cluster"

  # Single-zone cluster to reduce cost and avoid regional stockout
  location = var.zone

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  release_channel {
    channel = "REGULAR"
  }
}

# ---------------------------------------
# Node Pool
# ---------------------------------------
resource "google_container_node_pool" "primary_nodes" {

  name     = "acme-web-cluster-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  node_count = var.node_count

  node_config {

    machine_type = var.machine_type

    disk_size_gb = var.disk_size

    disk_type = "pd-standard"

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
