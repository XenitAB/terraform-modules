nameOverride: ""
fullnameOverride: ""
notificationEmail: "${notificationEmail}"
acmeServer: "${acmeServer}"

cloudProvider: "${cloudProvider}"

azureConfig:
  resourceGroupName: "${azureConfig.resource_group_name}"
  clientID: "${azureConfig.client_id}"
  subscriptionID: "${azureConfig.subscription_id}"
  hostedZoneName: "${azureHostedZoneName}"
  resourceID: "${azureConfig.resource_id}"

awsConfig:
  region: "${aws_config.region}"
  zones:
  %{~ for name, zone_id in aws_config.hosted_zone_id ~}
    - hostedZoneID: ${zone_id}
      name: ${name}
  %{~ endfor ~}
