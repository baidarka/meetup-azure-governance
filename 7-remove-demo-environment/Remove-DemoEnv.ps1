<#
  .SYNOPSIS
  Remove the demo resource group and policy

  .NOTES
  Coding style 'JustForHandsonLab'.

  .AUTHOR
  BernardB  https://github.com/baidarka/meetup-azure-governance
#>
[CmdletBinding()]
param (
    [Parameter (Mandatory=$false)]
    [string]$SubscriptionName = "Visual Studio Enterprise",

    [Parameter (Mandatory=$false)]
    [string]$ResourceGroupName = "rg-euw-meetup-demo",

    [Parameter (Mandatory=$false)]
    [string]$Location = "westeurope"
)

# Variables ###################################################################
$policyAssignmentNames = @("audit-storage-https-traffic-only", "audit-storage-networkAcls-deny")
$policyDefinitionNames = @("meetup-storage-https-traffic-only", "meetup-storage-networkAcls-deny")

# Login #######################################################################
if (!(Get-AzContext)) {
  Write-Warning "AzContext is null. Please login..."
  Connect-AzAccount
}
Set-AzContext -Subscription $SubscriptionName

# Remove policy assignments ###################################################
$policyAssignmentNames | 
  ForEach-Object Get-AzPolicyAssignment -Name $_ |
    Remove-AzPolicyAssignment -Id $_.ResourceId

# Remove resource group #######################################################
Write-Verbose -Message ("About to remove resource group '{0}'." -f $rgName)
Remove-AzResourceGroup -Name $rgName -Force

# Remove policy definition ####################################################
$policyDefinition = Get-AzPolicyDefinition -Name $policyName
Remove-AzPolicyDefinition -Id $policyDefinition.ResourceId -Force
