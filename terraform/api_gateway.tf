// API Gateway resource
resource "aws_apigatewayv2_api" "application_flow_api" {
  name          = "application-flow-api"
  protocol_type = "HTTP"
}

// API stage resource
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  name        = "$default"
  auto_deploy = true
}

// API Gateway integration resource for createApplication Lambda function
resource "aws_apigatewayv2_integration" "create_application_integration" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.create_application.invoke_arn
  integration_method = "POST"
}

// API Gateway route resource for createApplication
resource "aws_apigatewayv2_route" "create_application_route" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  route_key   = "POST /applications"
  target      = "integrations/${aws_apigatewayv2_integration.create_application_integration.id}"
}

// API Gateway integration resource for listApplications Lambda function
resource "aws_apigatewayv2_integration" "list_applications_integration" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.list_applications.invoke_arn
  integration_method = "POST"
}

// API Gateway route resource for listApplications
resource "aws_apigatewayv2_route" "list_applications_route" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  route_key   = "GET /applications"
  target      = "integrations/${aws_apigatewayv2_integration.list_applications_integration.id}"
}

// API Gateway integration resource for getApplication Lambda function
resource "aws_apigatewayv2_integration" "get_application_integration" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.get_application.invoke_arn
  integration_method = "POST"
}

// API Gateway route resource for getApplication
resource "aws_apigatewayv2_route" "get_application_route" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  route_key   = "GET /applications/{id}"
  target      = "integrations/${aws_apigatewayv2_integration.get_application_integration.id}"
}

// API Gateway integration resource for updateApplication Lambda function
resource "aws_apigatewayv2_integration" "update_application_integration" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.update_application.invoke_arn
  integration_method = "POST"
}

// API Gateway route resource for updateApplication
resource "aws_apigatewayv2_route" "update_application_route" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  route_key   = "PUT /applications/{id}"
  target      = "integrations/${aws_apigatewayv2_integration.update_application_integration.id}"
}

// API Gateway integration resource for deleteApplication Lambda function
resource "aws_apigatewayv2_integration" "delete_application_integration" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.delete_application.invoke_arn
  integration_method = "POST"
}

// API Gateway route resource for deleteApplication
resource "aws_apigatewayv2_route" "delete_application_route" {
  api_id      = aws_apigatewayv2_api.application_flow_api.id
  route_key   = "DELETE /applications/{id}"
  target      = "integrations/${aws_apigatewayv2_integration.delete_application_integration.id}"
}

// Lambda permission for API Gateway to invoke createApplication Lambda function
resource "aws_lambda_permission" "create_application_permission" {
  statement_id  = "allow_create_application"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.application_flow_api.execution_arn}/*/*"
}

// Lambda permission for API Gateway to invoke listApplications Lambda function
resource "aws_lambda_permission" "list_applications_permission" {
  statement_id  = "allow_list_applications"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_applications.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.application_flow_api.execution_arn}/*/*"
}

// Lambda permission for API Gateway to invoke getApplication Lambda function
resource "aws_lambda_permission" "get_application_permission" {
  statement_id  = "allow_get_application"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.application_flow_api.execution_arn}/*/*"
}

// Lambda permission for API Gateway to invoke updateApplication Lambda function
resource "aws_lambda_permission" "update_application_permission" {
  statement_id  = "allow_update_application"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.application_flow_api.execution_arn}/*/*"
}

// Lambda permission for API Gateway to invoke deleteApplication Lambda function
resource "aws_lambda_permission" "delete_application_permission" {
  statement_id  = "allow_delete_application"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.application_flow_api.execution_arn}/*/*"
}
