variable "aws_region" {
  description = "The AWS region to create things in."
  # Ireland
  default = "us-east-1"
}
# Use the command line to inject this variable
variable "personal_access_token" {
  description = "personal token"
  default     = "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"
}

variable "security_group_id" {
  default = "sg-0fa50cb42c0057ebe"
}