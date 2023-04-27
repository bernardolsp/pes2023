variable "cluster_name" {
  description = "Name of the EKS cluster to be created"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS cluster will be deployed"
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed"
}

variable "app_name" {
  description = "Name of the application to be deployed"
}

variable "app_repo_url" {
  description = "URL of the Git repository where the application code is hosted"
}

variable "app_repo_path" {
  description = "Path within the Git repository where the application code is located"
}

variable "path_app_name" {
  description = "Name of the application within the Kubernetes manifest"
}

variable "path_app" {
  description = "Path to the Kubernetes manifest that deploys the application"
}
