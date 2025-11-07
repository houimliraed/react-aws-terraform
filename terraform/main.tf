

resource "aws_s3_bucket" "react_app" {

  bucket = var.bucket_name

}

# these commented lines are used to test public access for the static site , not recommended to use in prod/real deployement

/* resource "aws_s3_bucket_website_configuration" "react_app_config" {

  bucket = aws_s3_bucket.react_app.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }

} */

/* resource "aws_s3_bucket_policy" "react_app_policy" {
  bucket = aws_s3_bucket.react_app.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.react_app.arn}/*"
      }
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.react_app_access ]

}

 */


resource "aws_s3_bucket_public_access_block" "react_app_access" {
  bucket                  = aws_s3_bucket.react_app.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# creating the certificate resource

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

data "aws_route53_record" "domain_zone" {
    name = "houimliraed.com"
  
}

resource "aws_route53_record" "react_app_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.react_app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_record.domain_zone.zone_id
}

resource "aws_acm_certificate_validation" "react_app_cert_validation" {

  certificate_arn         = aws_acm_certificate.react_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.react_app_cert_validation : record.fqdn]

}

