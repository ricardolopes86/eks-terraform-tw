variable "app_ns_name" {
  default = "frontend-ns"
  type = "string"
}

variable "app_label" {
  default = "frontend-lbl"
  type = "string"
}

variable "newsfeed_port" {
  default = 8080
}

variable "frontend_port" {
  default = 9000
}

variable "quotes_port" {
  default = 8081
}
