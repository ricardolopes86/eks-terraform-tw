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
          name  = "example"

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
      test = "frontend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        test = "frontend"
      }
    }

    template {
      metadata {
        labels {
          test = "frontend"
        }
      }

      spec {
        container {
          image = "ricardosilva/tw-frontend:0.1"
          name  = "frontend"

        }
        env {
            QUOTE_SERVICE_URL = ""
            NEWSFEED_SERVICE_URL = ""
        }
      }
    }
  }
}