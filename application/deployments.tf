resource "kubernetes_deployment" "newsfeed" {
  metadata {
    name = "terraform-newsfeed"
    labels {
      test = "newsfeed"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        test = "newsfeed"
      }
    }

    template {
      metadata {
        labels {
          test = "newsfeed"
        }
      }

      spec {
        container {
          image = "ricardosilva/tw-newsfeed:0.1"
          name  = "newsfeed"

        }
      }
    }
  }
}

resource "kubernetes_deployment" "quotes" {
  metadata {
    name = "terraform-quotes"
    labels {
      test = "quotes"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        test = "quotes"
      }
    }

    template {
      metadata {
        labels {
          test = "quotes"
        }
      }

      spec {
        container {
          image = "ricardosilva/tw-quotes:0.1"
          name  = "quotes"

        }
      }
    }
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "terraform-frontend"
    labels {
      test = "${var.app_label}"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        test = "${var.app_label}"
      }
    }

    template {
      metadata {
        labels {
          test = "${var.app_label}"
        }
      }

      spec {
        container {
          image = "ricardosilva/tw-frontend:0.1"
          name  = "frontend"

        }
        env {
          STATIC_URL="${kubernetes_service.static_app.metadata.0.ip}:${var.static_port}"
          NEWSFEED_SERVICE_TOKEN="${kubernetes_secret.newsfeed-secret}"
          QUOTE_SERVICE_URL = "${kubernetes_service.quotes_app.metadata.0.ip}${var.quotes_port}"
          NEWSFEED_SERVICE_URL = "${kubernetes_service.newsfeed_app.metadata.0.ip}${var.newsfeed_port}"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "static" {
  metadata {
    name = "terraform-static"
    labels {
      test = "static"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        test = "static"
      }
    }

    template {
      metadata {
        labels {
          test = "static"
        }
      }

      spec {
        container {
          image = "ricardosilva/tw-static:0.1"
          name  = "static"

        }
      }
    }
  }
}

resource "kubernetes_service" "quotes_app" {
  metadata {
    name      = "quotes_app"
    namespace = "${var.app_ns_name}"

    labels {
      app = "${var.app_label}"
    }
  }

  spec {
    selector {
      app = "quotes"
    }

    session_affinity = "ClientIP"

    port {
      port        = "${var.quotes_port}"
      target_port = "${var.quotes_port}"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "newsfeed_app" {
  metadata {
    name      = "newsfeed_app"
    namespace = "${var.app_ns_name}"

    labels {
      app = "${var.app_label}"
    }
  }

  spec {
    selector {
      app = "newsfeed"
    }

    session_affinity = "ClientIP"

    port {
      port        = "${var.newsfeed_port}"
      target_port = "${var.newsfeed_port}"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "frontend_app" {
  metadata {
    name      = "frontend_app"
    namespace = "${var.app_ns_name}"

    labels {
      app = "${var.app_label}"
    }
  }

  spec {
    selector {
      app = "frontend"
    }

    session_affinity = "ClientIP"

    port {
      port        = "${var.frontend_port}"
      target_port = "${var.frontend_port}"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "static_app" {
  metadata {
    name      = "static_app"
    namespace = "${var.app_ns_name}"

    labels {
      app = "${var.app_label}"
    }
  }

  spec {
    selector {
      app = "frontend"
    }

    session_affinity = "ClientIP"

    port {
      port        = "${var.frontend_port}"
      target_port = "${var.frontend_port}"
    }

    type = "ClusterIP"
  }
}