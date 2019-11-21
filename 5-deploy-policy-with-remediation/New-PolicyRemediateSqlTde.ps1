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

$sub = Get-AzSubscription -SubscriptionName $SubscriptionName
$par = Get-Content -Path "./policy-remediate-sql-tde/azurepolicy.parameters.json" -Raw
$pol = ((Get-Content -Path "./policy-remediate-sql-tde/azurepolicy.rules.json" -Raw) -f $sub.Id)

# Add policy definition ########################################################
# A policy definition can be added to a management group or a subscription.
$args = @{
    Name         = "meetup-remediate-sql-tde"
    DisplayName  = "SQL must use transparent data encryption"
    Description  = "SQL must use transparent data encryption"
    Subscription = (Get-AzContext).Subscription.Id
    Policy       = $pol
    Parameter    = $par
    Metadata     = '{ "category" : "SQL" }'
    Mode         = "All"
}

$definition = New-AzPolicyDefinition @args
$definition

# Assign policy definition to the resource group ##############################
$sub = Get-AzSubscription -SubscriptionName $SubscriptionName
$args = @{
    Name                = "audit-rem-sql-tde"
    Scope               = "/subscriptions/$($sub.Id)"
    PolicyDefinition    = $definition
}

$assignment = New-AzPolicyAssignment @args -AssignIdentity -Location "westeurope"
$assignment
