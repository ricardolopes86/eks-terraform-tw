# Setup the provider to connnect to Kubernetes cluster
provider "kubernetes" {
  config_context_auth_info = "aws"
  config_context_cluster   = "kubernetes"
  version                  = "1.11"
}

# Create the NameSpace where the application will run
resource "kubernetes_namespace" "microservices_app" {
  metadata {
    name = "${var.app_ns_name}"

    labels {
      app = "${var.app_label}"
    }
  }
}

# Create the ConfigMap inside the NameSpace
resource "kubernetes_config_map" "frontend" {
  metadata {
    name = "cm-frontend"

    labels {
      app = "${var.app_label}"
    }

    namespace = "${var.app_ns_name}"
  }

  data {
    QUOTE_SERVICE_URL = "${kubernetes_service.quotes_app.metadata.0.self_link}"
    NEWSFEED_SERVICE_URL = "${kubernetes_service.newsfeed_app.metadata.0.self_link}"
  }

  depends_on = ["kubernetes_namespace.microservices_app"]
}

resource "kubernetes_secret" "newsfeed-secret" {
  metadata {
    name = "newsfeed-secret"
  }

  namespace = "${kubernetes_namespace.microservices_app.metadata.name}"
  labels {
    app = "${var.app_label}"
  }

  data {
    NEWSFEED_SERVICE_TOKEN="T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX"
  }
}
