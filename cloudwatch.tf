resource "aws_cloudwatch_log_group" "for_ecs" {
  name = "/ecs/example"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name = "/ecs-scheduled-tasks/example"
  retention_in_days = 180
}

resource "aws_cloudwatch_event_rule" "example_batch" {
  name = "example_batch"
  description = "very important batch"
  schedule_expression = "cron(*/2 * * * ? *)"
}

resource "aws_cloudwatch_log_group" "operation" {
  name = "/operation"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_subscription_filter" "example" {
  name = "example"
  log_group_name = aws_cloudwatch_log_group.for_ecs_scheduled_tasks.name
  destination_arn = aws_kinesis_firehose_delivery_stream.example.arn
  filter_pattern = "[]"
  role_arn = module.cloudwatch_logs_role.iam_role_arn
}
