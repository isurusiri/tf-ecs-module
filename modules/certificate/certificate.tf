resource "aws_acm_certificate" "cert" {
  domain_name       = var.DOMAIN_NAME
  validation_method = "DNS"
  provider          = "aws.main-dev"

  tags = {
    Environment = var.ENV
  }

  lifecycle {
    create_before_destroy = true
  }
}
