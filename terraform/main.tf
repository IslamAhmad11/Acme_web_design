# Google Provider Configuration using your variables
provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC Network Definition
resource "google_compute_network" "vpc_network" {
  name                    = "acme-web-cluster-vpc"
  auto_create_subnetworks = false # Professional practice: always manage subnets manually
}

# Custom Subnet for GKE Nodes
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "acme-web-cluster-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24" # Isolated range for cluster nodes
}

# GKE Cluster Definition (Control Plane)
resource "google_container_cluster" "primary" {
  # NOTE: Cluster name is hardcoded to precisely match the GKE cluster name 
  # expected by the GitHub Actions CI/CD deployment pipeline (`deploy.yaml`).
  name     = "acme-web-cluster"
  location = var.region # Creates a regional cluster using your region variable

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  # Cost Optimization: Disable Cloud Logging and Monitoring services to avoid extra GCP charges
  logging_service    = "none"
  monitoring_service = "none"

  # Professional Hardening: Delete the default node pool immediately after creation
  remove_default_node_pool = true
  initial_node_count       = 1

  # Security Best Practice: Enable Workload Identity on the Control Plane
  # This is REQUIRED before enabling GKE_METADATA on the Node Pool below
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Custom Optimized Node Pool using your node_count variable
resource "google_container_node_pool" "primary_nodes" {
  name       = "acme-web-cluster-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count # Professional practice: dynamically set via your variables.tf

  node_config {
    # Cost Optimization: Use e2-medium (2 vCPUs, 4 GB RAM) - the cheapest standard machine type for GKE
    machine_type = "e2-medium" 

    # Budget Control: 30GB standard persistent disk is more than enough for static websites (Acme)
    disk_size_gb = 30
    disk_type    = "pd-standard"

    # Security Best Practice: Enable GKE Metadata Server for secure workload federation
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # IAM Scopes needed for basic cluster operations
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}
