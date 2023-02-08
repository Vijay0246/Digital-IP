resource "aws_ecr_repository" "ecr" {
  name                 = var.react_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}