resource "aws_s3_bucket" "s3_app_bucket" {
  bucket = var.project_name

  tags = {
    "Name" = "${var.project_name}"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_website_config" {
  bucket = aws_s3_bucket.s3_app_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_acl" "s3_app_bucket_acl" {
  bucket = aws_s3_bucket.s3_app_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.s3_app_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid = "Allow GET requests originating requests using the Referer header for ${var.project_name}"

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3_app_bucket.arn,
      "${aws_s3_bucket.s3_app_bucket.arn}/*",
    ]

    condition {
      test     = "StringLike"
      variable = "AWS:Referer"
      values   = ["${random_string.random.result}"]
    }
  }
}
