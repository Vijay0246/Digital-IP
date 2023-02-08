output "arn" {
  description = "ecr arn"
  value       = aws_ecr_repository.ecr.arn
}
output "registry_id" {
  description = "ecr registry id"
  value       = aws_ecr_repository.ecr.registry_id
}
output "repository_url" {
  description = "ECR repository url"
  value       = aws_ecr_repository.ecr.repository_url
}