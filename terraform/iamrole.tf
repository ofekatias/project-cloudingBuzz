resource "aws_iam_role" "lambda_role" {
name   = "lambda_role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "sns-attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.role_sns.arn
}
resource "aws_iam_role_policy_attachment" "api-attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.role_api.arn
}
resource "aws_iam_role_policy_attachment" "ec2-attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.role_ec2.arn

}

