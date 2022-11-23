resource "aws_s3_bucket" "s3_app_bucket" {
  bucket = var.project_name

  tags = {
    "Name" = "${var.project_name}"
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
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
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
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.s3_distribution.arn}"]
    }
  }
}
