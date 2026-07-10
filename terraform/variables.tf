variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
  default     = "us-central1"
}

variable "node_count" {
  description = "Number of GKE Nodes"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "GKE Machine Type"
  type        = string
  default     = "e2-small"
}
