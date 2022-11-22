resource "google_compute_address" "default" {
  name   = "tf-gke-helm-${var.app_name}"
  region = var.region
}

# Helm chart for app
resource "helm_release" "nginx" {
  repository = "https://charts.bitnami.com/bitnami"
  name       = "nginx"
  chart      = "nginx"

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

 depends_on = [google_container_cluster.default]
}

resource "helm_release" "grafana" {
 repository = "https://grafana.github.io/helm-charts/"
 name       = "grafana"
 chart      = "grafana"
 values = [
   "${file("./files/grafana/values.yaml")}"
 ]
 depends_on = [google_container_cluster.default] 
}

resource "helm_release" "loki" {
 repository = "https://grafana.github.io/helm-charts/"
 name       = "loki-stack"
 chart      = "loki-stack"
#  values = [
#    "${file("./files/grafana/values.yaml")}"
#  ]
 depends_on = [google_container_cluster.default] 
}

resource "helm_release" "prometheus" {
 repository = "https://prometheus-community.github.io/helm-charts"
 name       = "prometheus"
 chart      = "prometheus"
 timeout    = 600000
 wait       = true


 values = [
   "${file("./files/prometheus/values.yaml")}"
 ]
 depends_on = [google_container_cluster.default] 
}