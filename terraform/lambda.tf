resource "aws_lambda_function" "lambda_function" {
filename                       = "${path.module}/python/lambda_function.zip"
function_name                  = "lambda_function"
role                           = aws_iam_role.lambda_role.arn
handler                        = "lambda_function.lambda_handler"
runtime                        = "python3.8"
}

