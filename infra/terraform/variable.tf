variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "my_ip" {
  description = "Your local public IP address for restricted SSH access"
  type        = string
}

variable "key_name" {
  description = "SSH Key pair name"
  default     = "tsa_cloud"
  type        = string
}
