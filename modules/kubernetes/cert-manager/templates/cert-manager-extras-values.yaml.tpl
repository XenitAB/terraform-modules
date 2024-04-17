nameOverride: ""
fullnameOverride: ""
notificationEmail: "${notificationEmail}"
acmeServer: "${acmeServer}"

cloudProvider: "azure"

azureConfig:
  resourceGroupName: "${azureConfig.resource_group_name}"
  clientID: "${azureConfig.client_id}"
  subscriptionID: "${azureConfig.subscription_id}"
  hostedZoneNames: ${azureHostedZoneNames}
