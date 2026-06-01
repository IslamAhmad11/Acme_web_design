
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "acme_vpc" {
  name                    = "acme-custom-vpc"
  auto_create_subnetworks = false
  description             = "Custom VPC for Acme project - created by Terraform"
}

resource "google_compute_subnetwork" "acme_subnet" {
  name          = "acme-custom-subnet"
  network       = google_compute_network.acme_vpc.id
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_http" {
  name    = "acme-allow-http"
  network = google_compute_network.acme_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["acme-node"]
}

resource "google_container_cluster" "primary" {
  name       = "acme-web-cluster"
  location   = var.region
  network    = google_compute_network.acme_vpc.id
  subnetwork = google_compute_subnetwork.acme_subnet.id

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "main-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = var.node_count

  node_config {
    machine_type = "e2-micro"
    disk_size_gb = 30
    tags         = ["acme-node"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
