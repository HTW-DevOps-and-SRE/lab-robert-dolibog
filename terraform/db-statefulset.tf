resource "kubernetes_stateful_set" "postgres_db" {
  metadata {
    name = "postgres-db"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    service_name = "postgres"

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:latest"
          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = "mydatabase"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "db-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "db-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.db_claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "db_claim" {
  metadata {
    name = "db-storage"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}