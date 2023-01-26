terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.do_ssh_key_name
}

resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkinsVm"
  region   = "nyc1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "k8s"
  region  = var.region
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2

  }
}

variable "region" {
  type        = string
  default     = ""
  description = "Região padrão"
}

variable "do_token" {
  type        = string
  default     = ""
  description = "token atual"
}

variable "do_ssh_key_name" {
  type        = string
  default     = ""
  description = "minha chave cadastrada da DO"
}

output "jenkins_ip" {
  value = digitalocean_droplet.jenkins.ipv4_address
}

resource "local_file" "name" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kubeconfig.yaml"
}
