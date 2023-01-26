terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_42a29b8908aa9dd7da0b88482b0c09df3c4def301f773076f7f02559e9db56f3"
}

data "digitalocean_ssh_key" "mykey" {
  name = "mykey"
}

resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkinsVm"
  region   = "nyc1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.mykey.id]
}



resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "2.25.2"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2

  }
}
