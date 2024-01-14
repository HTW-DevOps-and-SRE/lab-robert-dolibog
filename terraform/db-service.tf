
resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    port {
      port = 5432
    }

    selector = {
      app = "postgres"
    }

    cluster_ip = "None"
  }
}
