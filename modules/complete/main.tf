## Usando módulo do Terraform Registry
## https://github.com/terraform-aws-modules/terraform-aws-eks/

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws  = ">= 2.0"
    helm = ">= 2.0"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
    token                  = module.eks.cluster_token
  }
}
provider "kubectl" {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
    token                  = module.eks.cluster_token
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.13.1"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_public_access  = true
  subnet_ids                      = var.subnet_ids
  vpc_id                          = var.vpc_id
  cluster_endpoint_private_access = false
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.medium", "t3a.large"]
  }
  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
    }
  }
}

## Deploying Argo in Helm release

resource "helm_release" "argo" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  timeout          = 600
  create_namespace = true
  lifecycle {
    ignore_changes = [
      namespace
    ]
  }
}

resource "kubectl_manifest" "applicationset" {
  yaml_body = templatefile("${path.module}/templates/applicationset.yaml.tpl", {
    app_name      = var.app_name
    app_repo_url  = var.app_repo_url
    app_repo_path = var.app_repo_path
    path_app_name = var.path_app_name
    path_app      = var.path_app
  })
  depends_on = [
    helm_release.argo
  ]
}