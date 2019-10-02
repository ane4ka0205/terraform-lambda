resource "aws_sqs_queue" "mde_kpi_dlq" {
  name_prefix               = "mdepki_dlq"
  delay_seconds             = 0
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue" "mde_kpi_queue" {
  name_prefix               = "mdepki_queue"
  delay_seconds             = 0
  message_retention_seconds = 1209600
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.mde_kpi_dlq.arn}\",\"maxReceiveCount\":5}"

}

