module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  cluster_endpoint_private_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
#   control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    # instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    eks_cluster = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.micro"]
	  capacity_type = "SPOT"

      min_size     = 1
      max_size     = 10
      desired_size = 3

	  vpc_security_group_ids = [aws_security_group.cluster_ssh.id]
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
#   enable_cluster_creator_admin_permissions = true

#   access_entries = {
#     # One access entry with a policy associated
#     example = {
#       kubernetes_groups = []
#       principal_arn     = "arn:aws:iam::123456789012:role/something"

#       policy_associations = {
#         example = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
#           access_scope = {
#             namespaces = ["default"]
#             type       = "namespace"
#           }
#         }
#       }
#     }
  }

# module "eks" {
#   source = "terraform-aws-modules/eks/aws"

#   cluster_name                    = var.cluster_name
#   cluster_version                 = "1.21"
#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true

#   vpc_id     = "vpc-1234556abcdef"
#   subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     ami_type               = "AL2_x86_64"
#     disk_size              = 50
#     instance_types         = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
#     vpc_security_group_ids = [aws_security_group.additional.id]
#   }

#   eks_managed_node_groups = {
#     blue = {}
#     green = {
#       min_size     = 1
#       max_size     = 10
#       desired_size = 1

#       instance_types = ["t3.large"]
#       capacity_type  = "SPOT"
#       labels = {
#         Environment = "test"
#         GithubRepo  = "terraform-aws-eks"
#         GithubOrg   = "terraform-aws-modules"
#       }
#       taints = {
#         dedicated = {
#           key    = "dedicated"
#           value  = "gpuGroup"
#           effect = "NO_SCHEDULE"
#         }
#       }
#       tags = {
#         ExtraTag = "example"
#       }
#     }
#   }
# }
