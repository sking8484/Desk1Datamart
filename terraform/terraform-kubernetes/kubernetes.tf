terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.57.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
  }
  cloud {
    organization = "Desk1Datamart"

    workspaces {
      name = "datamart-kubernetes"
    }
  }
}

data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "Desk1Datamart"
    workspaces = {
      name = "datamart-infrastructure"
    }
  }
}

# Retrieve EKS cluster information
provider "aws" {
  region = data.terraform_remote_state.eks.outputs.region
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "kubernetes_deployment" "rust-api" {
  metadata {
    name = "datamart-rust-api"
    labels = {
      App = "DataMartRustApi"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "DataMartRustApi"
      }
    }
    template {
      metadata {
        labels = {
          App = "DataMartRustApi"
        }
      }
      spec {
        container {
          image = "lebesgel/desk1_datamart"
          name  = "example"
          image_pull_policy = "Always"

          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "api-service" {
  metadata {
    name = "rust-api-load-balancer"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
    load_balancer_source_ranges = ["0.0.0.0/0"]
  }
}

output "lb_ip" {
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname
}

