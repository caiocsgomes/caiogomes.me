resource "aws_s3_bucket" "s3_app_bucket" {
  bucket = "${var.project_name}-app-bucket"

  tags = {
    "Name" = "${var.project_name}-app-bucket"
  }
}

resource "aws_s3_bucket_acl" "s3_app_bucket_acl" {
  bucket = aws_s3_bucket.s3_app_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3_app_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.s3_app_bucket.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3_app_bucket.arn,
      "${aws_s3_bucket.s3_app_bucket.arn}/*",
    ]
  }
}
