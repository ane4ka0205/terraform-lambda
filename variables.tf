variable "influx_port" {
  default = ""
}
variable "influx_host" {
  default = ""
}
variable "sonar_host" {
  default = ""
}
variable "jenkins_host" {
  default = ""
}
variable "measures_api" {
  default = ""
}
variable "region" {
  default = ""
}
variable "accountId" {
  default = ""
}
variable "rest-api-resource-name-sonar" {
  default = ""
}
variable "rest-api-resource-name-jenkins" {
  default = ""
}
variable "subnet_ids" {
  type = "list"
}
variable "security_group_ids" {
  default = ""
}

variable "lambda_sonar_go" {
  default = ""
}