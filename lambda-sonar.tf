resource "aws_lambda_permission" "allow-api-gateway-parent-resource-sonar" {
  function_name = "lambda_sonar"
  statement_id  = "allow-api-gateway-parent-resource-sonar"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.lambda_API.id}/*/${aws_api_gateway_method.lambda_sonar_API_Method.http_method}${aws_api_gateway_resource.lambda_sonar_Resource.path}"
}

locals {
  lambda_sonar_zip_location = "../sonar-metrics-lambda/main.zip"
}

data "archive_file" "main" {
  type        = "zip"
  source_file = "../sonar-metrics-lambda/main"
  output_path = "${local.lambda_sonar_zip_location}"
}

resource "aws_lambda_function" "lambda_sonar" {
  vpc_config {
    subnet_ids         = "${var.subnet_ids}"
    security_group_ids = ["${var.security_group_ids}"]
  }

  filename      = "${local.lambda_sonar_zip_location}"
  function_name = "lambda_sonar"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "main"
  runtime       = "go1.x"
  source_code_hash = "${filebase64sha256("../sonar-metrics-lambda/main.zip")}"

  environment {
    variables = {
      INFLUX_PORT  = "${var.influx_port}"
      INFLUX_HOST  = "${var.influx_host}"
      SONAR_HOST   = "${var.sonar_host}"
      MEASURES_API = "${var.measures_api}"
      SQS_QUE = ""
    }
  }
}
