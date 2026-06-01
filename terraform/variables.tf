variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "node_count" {
  description = "Number of GKE nodes"
  type        = number
  default     = 1
}
