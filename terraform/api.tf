resource "aws_api_gateway_rest_api" "MyAPI" {
  name        = "MyAPI"
endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "MyResource" {
  rest_api_id = aws_api_gateway_rest_api.MyAPI.id
  parent_id   = aws_api_gateway_rest_api.MyAPI.root_resource_id
  path_part   = "Mylambda"
}

resource "aws_api_gateway_method" "ANY" {
  rest_api_id   = aws_api_gateway_rest_api.MyAPI.id
  resource_id   = aws_api_gateway_resource.MyResource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.MyAPI.id}"
  resource_id = "${aws_api_gateway_method.ANY.resource_id}"
  http_method = "${aws_api_gateway_method.ANY.http_method}"

  integration_http_method = "ANY"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.lambda_function.invoke_arn}"
}
resource "aws_api_gateway_deployment" "test" {
 depends_on = [
        aws_api_gateway_method.ANY,
        aws_api_gateway_integration.lambda
      ]
  rest_api_id = "${aws_api_gateway_rest_api.MyAPI.id}"
  stage_name  = "test"
}
resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.MyAPI.execution_arn}/*/*"
}
resource "aws_api_gateway_method_response" "response_200" {
 rest_api_id = aws_api_gateway_rest_api.MyAPI.id
 resource_id = aws_api_gateway_resource.MyResource.id
 http_method = aws_api_gateway_method.ANY.http_method
 status_code = "200"

}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  depends_on = [
     aws_api_gateway_integration.lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.MyAPI.id
  resource_id = aws_api_gateway_resource.MyResource.id
  http_method = aws_api_gateway_method.ANY.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
 }
