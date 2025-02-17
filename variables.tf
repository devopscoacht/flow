
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

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "cluster-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.28"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}
