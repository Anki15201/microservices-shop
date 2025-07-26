output "instance_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.k8s_control_plane[*].public_ip
}

