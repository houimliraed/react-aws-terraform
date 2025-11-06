

resource "aws_s3_bucket" "react_app" {

  bucket = var.bucket_name

}

/* resource "aws_s3_bucket_website_configuration" "react_app_config" {

  bucket = aws_s3_bucket.react_app.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }

} */

resource "aws_s3_bucket_public_access_block" "react_app_access" {
    bucket = aws_s3_bucket.react_app.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}



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