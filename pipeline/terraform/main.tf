terraform {
  required_version = ">= 1.7.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
  }
}

variable "namespace" {
  description = "Namespace for NovaPay resources."
  type        = string
  default     = "novapay"
}

variable "image" {
  description = "Container image reference."
  type        = string
  default     = "novapay:latest"
}

# Provider authentication is intentionally supplied by the target environment
# rather than committed to this repository.
provider "kubernetes" {}

resource "kubernetes_namespace_v1" "novapay" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map_v1" "novapay_config" {
  metadata {
    name      = "novapay-config"
    namespace = kubernetes_namespace_v1.novapay.metadata[0].name
  }

  data = {
    APP_NAME = "novapay"
  }
}
