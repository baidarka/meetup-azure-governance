<#
  .SYNOPSIS
  Create a resource group with three storage accounts to play with

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

# Login #######################################################################
if (!(Get-AzContext)) {
  Write-Warning "AzContext is null. Please login..."
  Connect-AzAccount
}
Set-AzContext -Subscription $SubscriptionName

# Create a resource group #####################################################
New-AzResourceGroup -Name $rgName -Location $location -Tag @{ costCenter = "00042" }

# Create storage account ######################################################
# ==> This storage account is compliant with our demo policies
$sku = "Standard_LRS"
$kind = "StorageV2"
$accessTier = "Hot"
# Storage account names must be globally unique, so infuse a random id
$randomId = Get-Random -Minimum 10000 -Maximum 99999

$args = @{
  ResourceGroupName = $rgName
  Name              = ("stdemocompliant{0}" -f $randomId)
  Location          = $location
  SkuName           = $sku
  Kind              = $kind
  AccessTier        = $accessTier
  NetworkRuleSet    = (@{bypass="Logging,Metrics"; defaultAction="deny"}) # add ipRules and/or virtualNetworkRules
  EnableHttpsTrafficOnly = $true
}

New-AzStorageAccount @args

# Create storage account ######################################################
# ==> This storage account allows http traffic
$args = @{
  ResourceGroupName = $rgName
  Name              = ("stdemohttps{0}" -f $randomId)
  Location          = $location
  SkuName           = $sku
  Kind              = $kind
  AccessTier        = $accessTier
  NetworkRuleSet    = (@{bypass="Logging,Metrics"; defaultAction="deny"}) # add ipRules and/or virtualNetworkRules
  EnableHttpsTrafficOnly = $false
}

New-AzStorageAccount @args

# Create storage account ######################################################
# ==> this storage account does not use a network rule set
$args = @{
  ResourceGroupName = $rgName
  Name              = ("stdemonetwork{0}" -f $randomId)
  Location          = $location
  SkuName           = $sku
  Kind              = $kind
  AccessTier        = $accessTier
  EnableHttpsTrafficOnly = $true
}

New-AzStorageAccount @args

# List your storage accounts
Get-AzStorageAccount -ResourceGroupName $rgName
