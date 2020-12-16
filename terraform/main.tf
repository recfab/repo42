terraform {
  backend "http" {}

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.3.0"
    }
  }
}

provider "digitalocean" {
  #   token read from envvar DIGITALOCEAN_TOKEN
  #   token = var.do_token
}

data "digitalocean_kubernetes_versions" "main" {
  version_prefix = "1.18."
}

resource "digitalocean_kubernetes_cluster" "development" {
  name         = "recfab-development"
  auto_upgrade = true
  region       = "sfo3"
  version      = data.digitalocean_kubernetes_versions.main.latest_version

  node_pool {
    name = "pool-kd4zwylv8"
    size = "s-1vcpu-2gb"

    node_count = 1
  }

  tags = ["development"]
}
