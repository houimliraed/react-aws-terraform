# =====================
#  CloudFront Distribution for React App
# ====================

resource "aws_cloudfront_distribution" "react_app_cdn" {
  origin {
    domain_name = aws_s3_bucket.react_app.bucket_regional_domain_name
    origin_id   = "s3-react-app"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.react_app_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront for React App"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-react-app"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.react_app_cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "React App CDN"
  }
}

# ===============
#  CloudFront Origin Access Identity
# ================
resource "aws_cloudfront_origin_access_identity" "react_app_oai" {
  comment = "OAI for React App CloudFront"
}

# =========
#  S3 Bucket Policy to allow CloudFront OAI access
# ===============
resource "aws_s3_bucket_policy" "react_app_policy" {
  bucket = aws_s3_bucket.react_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.react_app_oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.react_app.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.react_app_access]
}
