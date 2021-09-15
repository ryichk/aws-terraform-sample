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
