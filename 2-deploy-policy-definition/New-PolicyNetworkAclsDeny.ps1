<#
  .SYNOPSIS
  Deploy and assign a policy.

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

# https://docs.microsoft.com/en-us/azure/governance/policy/samples/ensure-https-storage-account
# Get-Module -ListAvailable Az

# Login #######################################################################
if (!(Get-AzContext)) {
    Write-Warning "AzContext is null. Please login..."
    Connect-AzAccount
  }
Set-AzContext -Subscription $SubscriptionName

# Ensure that the resource provider is registered #############################
Register-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights'

# Get the id of the demo resource group #######################################
$rg = Get-AzResourceGroup -Name $ResourceGroupName

# Add policy definition ########################################################
# A policy definition can be added to a management group or a subscription.
$args = @{
    Name         = "meetup-storage-networkAcls-deny"
    DisplayName  = "Audit Storage accounts that allow access from all networks"
    Description  = "Storage accounts should specify allowed subnets and/or ip ranges, and should not allow access from all networks."
    Subscription = (Get-AzContext).Subscription.Id
    Policy       = "https://raw.githubusercontent.com/baidarka/meetup-azure-governance/master/2-deploy-policy-definition/policy-audit-networkAcls-deny/azurepolicy.rules.json"
    Parameter    = "https://raw.githubusercontent.com/baidarka/meetup-azure-governance/master/2-deploy-policy-definition/policy-audit-networkAcls-deny/azurepolicy.parameters.json"
    Metadata     = '{ "category" : "Storage" }'
    Mode         = "All"
}

$definition = New-AzPolicyDefinition @args
$definition

# Assign policy definition to the resource group ##############################
$args = @{
    Name                = "audit-storage-networkAcls-deny"
    Scope               = $rg.ResourceId
    PolicyDefinition    = $definition
}

$assignment = New-AzPolicyAssignment @args
$assignment
