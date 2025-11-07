# ============================================================
#  S3 Bucket for React App
# ============================================================

resource "aws_s3_bucket" "react_app" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "react_app_access" {
  bucket                  = aws_s3_bucket.react_app.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================
#  ACM Certificate + Route53 DNS Validation
# ============================================================

# 1️⃣ Get your hosted zone (replace with your domain)
data "aws_route53_zone" "domain_zone" {
  name         = "houimliraed.com."
  private_zone = false
}

# 2️⃣ Request a certificate
resource "aws_acm_certificate" "react_app_cert" {
  domain_name       = "houimliraed.com"
  validation_method = "DNS"

  tags = {
    Name = "react_app SSL certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 3️⃣ Create DNS validation records automatically
resource "aws_route53_record" "react_app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.react_app_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

# 4️⃣ Validate the certificate using the created DNS records
resource "aws_acm_certificate_validation" "react_app_cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.react_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.react_app_cert_validation : record.fqdn]
}
