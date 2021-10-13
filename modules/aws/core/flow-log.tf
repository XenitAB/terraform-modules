data "aws_region" "current" {}

resource "aws_flow_log" "this" {
  for_each = {
    for s in ["flowlog"] :
    s => s
    if var.flow_log_enabled
  }

  iam_role_arn    = aws_iam_role.flow_log[each.key].arn
  log_destination = aws_cloudwatch_log_group.this[each.key].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = {
    for s in ["flowlog"] :
    s => s
    if var.flow_log_enabled
  }
  name = "${data.aws_region.current.name}-${var.environment}-${var.name}-cloudwatch"
}

resource "aws_iam_role" "flow_log" {
  for_each = {
    for s in ["flowlog"] :
    s => s
    if var.flow_log_enabled
  }
  name = "${data.aws_region.current.name}-${var.environment}-${var.name}-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "flow_log" {
  for_each = {
    for s in ["flowlog"] :
    s => s
    if var.flow_log_enabled
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["${aws_cloudwatch_log_group.this[each.key].arn}:log-stream:*"]
  }
}

resource "aws_iam_role_policy" "flow_log" {
  for_each = {
    for s in ["flowlog"] :
    s => s
    if var.flow_log_enabled
  }
  name   = "${data.aws_region.current.name}-${var.environment}-${var.name}-cloudwatch"
  role   = aws_iam_role.flow_log[each.key].id
  policy = data.aws_iam_policy_document.flow_log[each.key].arn.json
}
