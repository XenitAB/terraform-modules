<#
    .SYNOPSIS
        This Azure Automation runbook automates the scheduled shutdown and startup of AKS Clusters in an Azure subscription. 

    .DESCRIPTION
        This is a PowerShell runbook, as opposed to a PowerShell Workflow runbook.
	    Note that the Automation Account will need RBAC permission on the Cluster (scoped directly or inherited) in order to
	    perform the start/stop operation.

    .PARAMETER ResourceGroupName
        The name of the ResourceGroup where the AKS Cluster is located
    
    .PARAMETER AksClusterName
        The name of the AKS Cluster to manage
    
    .PARAMETER Operation
        Currently supported operations are 'start-cluster' and 'stop-cluster'

	.PARAMETER AlertsEnabled
		Flag indicating if metric alerts are enabled on audit logs

	.PARAMETER AlertResourceGroupName
		The resource group name where the metric alert is enabled

	.PARAMETER AlertName
		Name of an alert to disable/enable
    
    .INPUTS
        None.

    .OUTPUTS
        Human-readable informational and error messages produced during the job. Not intended to be consumed by another runbook.
#>

Param(
    	[parameter(Mandatory=$true)]
	[String] $ResourceGroupName,
    	[parameter(Mandatory=$true)]
	[String] $AksClusterName,
    	[parameter(Mandatory=$true)]
		[ValidateSet('start-cluster','stop-cluster')]
    [String]$Operation,
		[parameter(Mandatory=$true)]
	[bool] $AlertsEnabled,
		[parameter(Mandatory=$false)]
	[String] $AlertResourceGroupName,
		[parameter(Mandatory=$false)]
	[String] $AlertName
)
	
try
{
	Disable-AzContextAutosave -Scope Process
		
	Write-Output "Logging into Azure with User Assigned Managed Identity"
    Connect-AzAccount -Identity -AccountId '${principal_id}'

    Write-Output "Set and store context"
    Set-AzContext -Subscription '${subscription_id}'
}
catch {
	Write-Error -Message $_.Exception
	throw $_.Exception
}

Write-Output "Performing $Operation"

try {
	switch -CaseSensitive ($Operation)
	{
		'start-cluster'
		{
			Write-Output "Starting Cluster $AksClusterName in resource group $ResourceGroupName"
			Start-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $AksClusterName
			Write-Output "Cluster started"

			if ($AlertsEnabled)
			{
				Write-Output "Enabling alert rule '$AlertName'"
				Get-AzMetricAlertRuleV2 -ResourceGroupName $AlertResourceGroupName -Name $AlertName | Add-AzMetricAlertRuleV2 -DisableRule:$false
				Write-Output "Alert rule '$AlertName' enabled"
			}
		}
		'stop-cluster'
		{
			Write-Output "Stopping Cluster $AksClusterName in resource group $ResourceGroupName"
			Stop-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $AksClusterName
			Write-Output "Cluster stopped"

			if ($AlertsEnabled)
			{
				Write-Output "Disabling alert rule '$AlertName'"
				Get-AzMetricAlertRuleV2 -ResourceGroupName $AlertResourceGroupName -Name $AlertName | Add-AzMetricAlertRuleV2 -DisableRule:$true
				Write-Output "Alert rule '$AlertName' disabled"
			}
		}
	}
}
catch {
	Write-Error -Message $_.Exception
	throw $_.Exception
}

Write-Output "Operation $Operation done"