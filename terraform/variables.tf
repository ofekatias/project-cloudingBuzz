variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list
  default = [
"arn:aws:iam::aws:policy/AmazonEC2FullAccess",
"arn:aws:iam::aws:policy/AmazonSNSFullAccess"]
}
