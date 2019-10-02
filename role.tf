resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = "${file("iam/lambda_policy.json")}"
}

resource "aws_iam_policy" "sqs_policy" {
  name        = "sqs_policy"
  path        = "/"
  description = "Policy for sqs"

  policy = "${file("iam/sqs_policy_for_lambda.json")}"

}

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "lambda-policy-attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy_attachment" "sqs-policy-attach" {
  name       = "lambda-policy-attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "${aws_iam_policy.sqs_policy.arn}"
}
