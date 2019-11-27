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
$policyAssignmentNames = @("Meetup audit storage https traffic only", "Meetup audit storage networkAcls deny")
$policyDefinitionNames = @("meetup-storage-https-traffic-only", "meetup-storage-networkAcls-deny")

# Login #######################################################################
if (!(Get-AzContext)) {
  Write-Warning "AzContext is null. Please login..."
  Connect-AzAccount
}
Set-AzContext -Subscription $SubscriptionName

# Remove policy assignments ###################################################
$rg = Get-AzResourceGroup -Name $ResourceGroupName
foreach ($policyAssignmentName in $policyAssignmentNames) {
  $policyAssignment = Get-AzPolicyAssignment -Name $policyAssignmentName -Scope $rg.ResourceId
  if ($null -ne $policyAssignment) {
    Remove-AzPolicyAssignment -Id $policyAssignment.ResourceId
  }
}

# Remove resource group #######################################################
Write-Verbose -Message ("About to remove resource group '{0}'." -f $ResourceGroupName)
Remove-AzResourceGroup -Name $ResourceGroupName -Force

# Remove policy definition ####################################################
foreach ($policyDefinitionName in $policyDefinitionNames) {
  $policyDefinition = Get-AzPolicyDefinition -Name $policyDefinitionName
  if ($null -ne $policyDefinition) {
    Remove-AzPolicyDefinition -Id $policyDefinition.ResourceId -Force
  }
}
