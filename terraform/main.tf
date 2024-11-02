# main.tf

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# -----------------------------
# User Service Deployment and Service
# -----------------------------
resource "kubernetes_deployment" "user_service" {
  metadata {
    name = "user-service-deployment"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "user-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "user-service"
        }
      }
      spec {
        container {
          image = "baseerburney/user-service:latest"
          name  = "user-service"
          port {
            container_port = 4001
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "user_service" {
  metadata {
    name = "user-service"
  }
  spec {
    selector = {
      app = "user-service"
    }
    port {
      port        = 4001
      target_port = 4001
    }
  }
}

# -----------------------------
# Order Service Deployment and Service
# -----------------------------
resource "kubernetes_deployment" "order_service" {
  metadata {
    name = "order-service-deployment"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "order-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "order-service"
        }
      }
      spec {
        container {
          image = "baseerburney/order-service:latest"
          name  = "order-service"
          port {
            container_port = 5001
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "order_service" {
  metadata {
    name = "order-service"
  }
  spec {
    selector = {
      app = "order-service"
    }
    port {
      port        = 5001
      target_port = 5001
    }
  }
}

# -----------------------------
# Product Service Deployment and Service
# -----------------------------
resource "kubernetes_deployment" "product_service" {
  metadata {
    name = "product-service-deployment"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "product-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "product-service"
        }
      }
      spec {
        container {
          image = "baseerburney/product-service:latest"
          name  = "product-service"
          port {
            container_port = 6001
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "product_service" {
  metadata {
    name = "product-service"
  }
  spec {
    selector = {
      app = "product-service"
    }
    port {
      port        = 6001
      target_port = 6001
    }
  }
}
