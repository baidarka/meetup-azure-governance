
# Goal: Create three storage accounts to play with

$subscriptionName = "Visual Studio Enterprise"
$rgName = "rg-euw-meetup-demo"
$location = "westeurope"

# Login #######################################################################
if (!(Get-AzContext)) {
  Connect-AzAccount
  Set-AzContext -Subscription $SubscriptionName | Out-Null
}

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
  Name              = ("stgdemocompliant{0}" -f $randomId)
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
  Name              = ("stgdemohttps{0}" -f $randomId)
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
  Name              = ("stgdemonetwork{0}" -f $randomId)
  Location          = $location
  SkuName           = $sku
  Kind              = $kind
  AccessTier        = $accessTier
  EnableHttpsTrafficOnly = $true
}

New-AzStorageAccount @args

# List your storage accounts
Get-AzStorageAccount -ResourceGroupName $rgName
