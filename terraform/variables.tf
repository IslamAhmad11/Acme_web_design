variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
}

variable "zone" {
  description = "Google Cloud Zone"
  type        = string
}

variable "machine_type" {
  description = "GKE node machine type"
  type        = string
}

variable "disk_size" {
  description = "Boot disk size (GB)"
  type        = number
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
}
