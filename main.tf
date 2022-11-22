/*
This is a cluster definition for GCE+Terraform for project
*/

resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}

data "google_client_config" "current" {}
# We create a public IP addresses for cluster 
resource "google_compute_network" "default" {
  name                    = "network-${random_string.random.result}"
  auto_create_subnetworks = false
}

# Configurations for local network
resource "google_compute_subnetwork" "default" {
  name                     = "network-${random_string.random.result}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

data "google_container_engine_versions" "default" {
  location = var.location
}

# Configurations for cluster
resource "google_container_cluster" "default" {
  name               = var.app_name
  project            = var.project
  location           = var.location
  initial_node_count = var.node_count
  # node configs 
  node_config {
    machine_type = var.instance_type
    labels = {
      all-pools-example = "true"
    }

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = false
  }

  min_master_version = data.google_container_engine_versions.default.latest_master_version
  network            = google_compute_subnetwork.default.name
  subnetwork         = google_compute_subnetwork.default.name

  enable_legacy_abac = true

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  provider = google-beta
  
  cluster_autoscaling {
    enabled = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 4
    }
    resource_limits {
      resource_type = "memory"
      minimum = 4
      maximum = 16
    }
  }
}

# Horizontal pod autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx" {
  metadata {
    name = "nginx"
  }

  spec {
    min_replicas = 3
    max_replicas = 6

    scale_target_ref {
      kind = "Deployment"
      name = "nginx"
    }
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type  = "AverageValue"
          average_value = "1000m"
        }
      }
    }
  }
}

# Docker Hub keys for privat registry
# resource "kubernetes_secret" "app" {
#   metadata {
#     name = "app"
#   }

#   type = "kubernetes.io/dockerconfigjson"

#   data = {
#     ".dockerconfigjson" = jsonencode({
#       auths = {
#         "${var.registry_server}" = {
#           "username" = var.registry_username
#           "password" = var.registry_password
#           "email"    = var.registry_email
#           "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
#         }
#       }
#     })
#   }
# }

resource "google_compute_health_check" "tcp-health-check" {
  name        = "tcp-health-check-${random_string.random.result}"
  description = "Health check via tcp"

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  tcp_health_check {
    port_name          = "nginx"
    port               = "80"
    # port_specification = "USE_NAMED_PORT"
    request            = "ARE YOU HEALTHY?"
    proxy_header       = "NONE"
    response           = "I AM HEALTHY"
  }
}

output "network" {
  value = google_compute_subnetwork.default.network
}

output "subnetwork_name" {
  value = google_compute_subnetwork.default.name
}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_region" {
  value = var.region
}

output "cluster_zone" {
  value = google_container_cluster.default.location
}