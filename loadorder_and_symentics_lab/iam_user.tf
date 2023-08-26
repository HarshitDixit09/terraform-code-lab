resource "aws_iam_user" "iam" {
  name = var.iam_user
  path = "/system/"
}