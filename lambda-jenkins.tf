resource "aws_lambda_permission" "allow-api-gateway-parent-resource-jenkins" {
  function_name = "lambda_jenkins"
  statement_id  = "allow-api-gateway-parent-resource-jenkins"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.lambda_API.id}/*/${aws_api_gateway_method.lambda_jenkins_API_Method.http_method}${aws_api_gateway_resource.lambda_jenkins_Resource.path}"
}

locals {
  lambda_jenkins_zip_location = "../jenkins-metrics-go-lambda/main.zip"
}

# data "archive_file" "main_jenkins" {
#   type        = "zip"
#   source_file = "../jenkins-metrics-go-lambda/main"
#   output_path = "${local.lambda_jenkins_zip_location}"
# }

resource "aws_lambda_function" "lambda_jenkins" {
  vpc_config {
    subnet_ids         = "${var.subnet_ids}"
    security_group_ids = ["${var.security_group_ids}"]
  }

  filename      = "${local.lambda_jenkins_zip_location}"
  function_name = "lambda_jenkins"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "main"
  runtime       = "go1.x"
  source_code_hash = "${filebase64sha256("../jenkins-metrics-go-lambda/main.zip")}"

  environment {
    variables = {
      INFLUX_PORT  = "${var.influx_port}"
      INFLUX_HOST  = "${var.influx_host}"
      JENKINS_HOST   = "${var.jenkins_host}"
      SQS_QUE = ""
    }
  }
}
