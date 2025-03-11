# module "networking" {
#   source = "../networking"
#   vpc_cidr = var.vpc_cidr
#   public_subnet_cidrs  = var.public_subnet_cidrs
#   availability_zones   = var.availability_zones
#   aws_region           = var.aws_region
#   private_subnet_cidrs = var.private_subnet_cidrs
# }
# module "iam" {
#   source = "../iam"
#   eks_worker_node_role  = var.eks_worker_node_role
#   eks_cluster_role_name = var.eks_cluster_role_name
# }
# Tạo IAM role EKS Cluster

data "aws_vpc" "existing" {
  id = var.vpc_id
}
# Tạo EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = var.eks_sg
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_blocks] #[module.networking.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {}
}
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_name_arm #module.iam.eks_cluster_role_arn
  version     = var.kubernetes_version
  vpc_config {
    subnet_ids = var.public_subnet_ids #module.networking.private_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
  
}
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn #module.iam.eks_work_node_role_arn
  ami_type        = var.ami_type
  instance_types  = [var.instance_types]
  subnet_ids = var.public_subnet_ids #module.networking.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  depends_on = [aws_eks_cluster.eks]
}