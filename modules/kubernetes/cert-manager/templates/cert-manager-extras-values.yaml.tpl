nameOverride: ""
fullnameOverride: ""
notificationEmail: "${notificationEmail}"
acmeServer: "${acmeServer}"

cloudProvider: "${cloudProvider}"

azureConfig:
  resourceGroupName: "${azureConfig.resource_group_name}"
  clientID: "${azureConfig.client_id}"
  subscriptionID: "${azureConfig.subscription_id}"
  hostedZoneNames: ${azureHostedZoneNames}
  resourceID: "${azureConfig.resource_id}"

awsConfig:
  region: "${awsConfig.region}"
  zones:
  %{~ for name, zone_id in awsConfig.hosted_zone_id ~}
    - hostedZoneID: ${zone_id}
      name: ${name}
  %{~ endfor ~}
