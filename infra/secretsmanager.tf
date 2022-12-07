resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "aws_secretsmanager_secret" "s3_custom_header_secret" {
  name_prefix = var.project_name
}

resource "aws_secretsmanager_secret_version" "s3_custom_header_secret_value" {
  secret_id     = aws_secretsmanager_secret.s3_custom_header_secret.id
  secret_string = random_string.random.result
}
