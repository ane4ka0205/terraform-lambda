resource "aws_api_gateway_rest_api" "lambda_API" {
  name        = "lambda_API"
  description = "This is API for lambda function"
}

resource "aws_api_gateway_resource" "lambda_sonar_Resource" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  parent_id   = "${aws_api_gateway_rest_api.lambda_API.root_resource_id}"
  path_part   = "${var.rest-api-resource-name-sonar}"
}

resource "aws_api_gateway_resource" "lambda_jenkins_Resource" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  parent_id   = "${aws_api_gateway_rest_api.lambda_API.root_resource_id}"
  path_part   = "${var.rest-api-resource-name-jenkins}"
}

resource "aws_api_gateway_method" "lambda_sonar_API_Method" {
  rest_api_id   = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id   = "${aws_api_gateway_resource.lambda_sonar_Resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "lambda_jenkins_API_Method" {
  rest_api_id   = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id   = "${aws_api_gateway_resource.lambda_jenkins_Resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda_sonar_API_Integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id             = "${aws_api_gateway_resource.lambda_sonar_Resource.id}"
  http_method             = "${aws_api_gateway_method.lambda_sonar_API_Method.http_method}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.accountId}:function:${var.rest-api-resource-name-sonar}/invocations"
  timeout_milliseconds    = 15000
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration" "lambda_jenkins_API_Integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id             = "${aws_api_gateway_resource.lambda_jenkins_Resource.id}"
  http_method             = "${aws_api_gateway_method.lambda_jenkins_API_Method.http_method}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.accountId}:function:${var.rest-api-resource-name-jenkins}/invocations"
  timeout_milliseconds    = 15000
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "method_sonar_response" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id = "${aws_api_gateway_resource.lambda_sonar_Resource.id}"
  http_method = "${aws_api_gateway_method.lambda_sonar_API_Method.http_method}"
  status_code = "200"

  response_models = {
        "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "method_jenkins_response" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id = "${aws_api_gateway_resource.lambda_jenkins_Resource.id}"
  http_method = "${aws_api_gateway_method.lambda_jenkins_API_Method.http_method}"
  status_code = "200"

  response_models = {
        "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "SonarIntegrationResponse" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id = "${aws_api_gateway_resource.lambda_sonar_Resource.id}"
  http_method = "${aws_api_gateway_method.lambda_sonar_API_Method.http_method}"
  status_code = "${aws_api_gateway_method_response.method_sonar_response.status_code}"
}

resource "aws_api_gateway_integration_response" "JenkinsIntegrationResponse" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  resource_id = "${aws_api_gateway_resource.lambda_jenkins_Resource.id}"
  http_method = "${aws_api_gateway_method.lambda_jenkins_API_Method.http_method}"
  status_code = "${aws_api_gateway_method_response.method_jenkins_response.status_code}"
}

resource "aws_api_gateway_deployment" "api_sonar_deployment" {
  depends_on = ["aws_api_gateway_integration.lambda_sonar_API_Integration"]

  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  stage_name  = "dev"

}

resource "aws_api_gateway_deployment" "api_jenkinsi_deployment" {
  depends_on = ["aws_api_gateway_integration.lambda_jenkins_API_Integration"]

  rest_api_id = "${aws_api_gateway_rest_api.lambda_API.id}"
  stage_name  = "dev"

}