resource "kubernetes_deployment" "web_deployment" {
  metadata {
    name = "web-deployment"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "web"
      }
    }
    template {
      metadata {
        labels = {
          app = "web"
        }
      }
      spec {
        container {
          name  = "web"
          image = "robertdolibog/app_docker:latest"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}