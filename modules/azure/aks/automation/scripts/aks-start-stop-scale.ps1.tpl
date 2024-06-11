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
    [String]$Operation
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
		}
		'stop-cluster'
		{
			Write-Output "Stopping Cluster $AksClusterName in resource group $ResourceGroupName"
			Stop-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $AksClusterName
			Write-Output "Cluster stopped"
		}
	}
}
catch {
	Write-Error -Message $_.Exception
	throw $_.Exception
}

Write-Output "Operation $Operation done"