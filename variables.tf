
variable "AmazonEC2ContainerRegistryFullAccess" {
  description = "AmazonEC2ContainerRegistryFullAccess policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
variable "AmazonS3FullAccess" {
  description = "AmazonS3FullAccess policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
variable "CloudWatchLogsFullAccess" {
  description = "CloudWatchLogsFullAccess policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}


variable "ecr_repo_name" {
  description = "demo ecr repo name"
  type        = string
  default     = "demo-ecr-repo"
}



variable "app_name" {
  description = "app name"
  type        = string
  default     = "demo-app"
}

variable "image_tag" {
  description = "image tag"
  type        = string
  default     = "latest"
}


variable "buildspec" {
  description = "buildspec"
  type        = string
  default     = "pipeline_files/buildspec.yml"
}

variable "deployspec" {
  description = "deployspec"
  type        = string
  default     = "pipeline_files/deployspec.yml"
}

variable "testspec" {
  description = "testspec"
  type        = string
  default     = "pipeline_files/testspec.yml"
}
variable "lintspec" {
  description = "lintspec"
  type        = string
  default     = "pipeline_files/lintspec.yml"
}

variable "eks_cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "voting-app"
}
