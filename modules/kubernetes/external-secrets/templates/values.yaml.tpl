env:
  AWS_REGION: ${aws_config.region}
  AWS_DEFAULT_REGION: ${aws_config.region}
  LOG_LEVEL: warn

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "${aws_config.role_arn}"

securityContext:
  fsGroup: 65534
