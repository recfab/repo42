data "digitalocean_kubernetes_versions" "this" {
  version_prefix = "1.21."
}

resource "digitalocean_tag" "environment" {
  name = "env:${var.environment}"
}

resource "digitalocean_kubernetes_cluster" "this" {
  name         = "${var.environment}-${var.region}-cluster"
  auto_upgrade = true
  region       = var.region
  version      = data.digitalocean_kubernetes_versions.this.latest_version

  node_pool {
    # cspell:disable
    name = "default"
    size = "s-1vcpu-2gb"
    # cspell:enable

    node_count = 1
  }

  tags = [
    digitalocean_tag.environment.id
  ]
}
