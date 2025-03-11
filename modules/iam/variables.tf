variable "eks_worker_node_role" {
    description = "EKS worker node role name"
    type = string
}
# variable "tags" {
#     description = "A map of tags to add to all resources"
#     type        = map(string)
# }
variable "eks_cluster_role_name" {
  description = "EKS cluster role name"
  type = string
}