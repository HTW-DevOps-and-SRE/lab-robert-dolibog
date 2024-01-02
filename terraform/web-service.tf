resource "kubernetes_service" "web_service" {
  metadata {
    name = "web-service"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "web"
    }
    port {
      port        = 5000
      target_port = 5000
    }
  }
}