output "certificate_name" {
  value = aws_acm_certificate.cert.domain_name
}
