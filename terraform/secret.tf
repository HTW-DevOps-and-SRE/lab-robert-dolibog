resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name = "postgres-secret"
  }
  type = "Opaque"
  data = {
    password = "OTg3NjU0MzI="
  }
}