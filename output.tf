output "lambda_sonar_arn" {
  value = "${aws_lambda_function.lambda_sonar.arn}"
}

output "lambda_jenkins_arn" {
  value = "${aws_lambda_function.lambda_jenkins.arn}"
}

output "sqs_policy_arn" {
  value = "${aws_iam_policy.sqs_policy.arn}"
}