locals {
  # if not defined : auto select
  # if true -> astreinte
  # if false -> alert only
  sns_topic = var.sns_topic_astreinte == null ? 
                ((module.label.environment == "prod" || module.label.environment == "prd") ? data.aws_sns_topic.astreinte.arn : data.aws_sns_topic.alert.arn) : 
                (var.sns_topic_astreinte ? data.aws_sns_topic.astreinte.arn : data.aws_sns_topic.alert.arn)
}
variable "sns_topic_astreinte" {
  type    = bool
  default = null
}
data "aws_sns_topic" "astreinte" {
  provider = aws.keenobi_hub
  name     = "keenobi-hub-prod-sns-astreinte"
}
data "aws_sns_topic" "alert" {
  provider = aws.keenobi_hub
  name     = "keenobi-hub-prod-sns-alert"
}
