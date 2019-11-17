
# Create three storage accounts to play with

$subscriptionName = "Visual Studio Enterprise"
$rgName = "rg-euw-meetup-demo"
$location = "westeurope"

# Login
if (!(Get-AzContext)) {
  Connect-AzAccount
  Set-AzContext -Subscription $SubscriptionName | Out-Null
}

# Create a resource group
New-AzResourceGroup -Name $rgName -Location $location -Tag @{ costCenter = "00042" }

# Create storage account stgdemocompliant
$sku = "Standard_LRS"
$kind = "StorageV2"
$accessTier = "Hot"

$args = @{
  Name            = "stgdemocompliant"
  Location        = $location
  SkuName         = $sku
  Kind            = $kind
  AccessTier      = $accessTier
  NetworkRuleSet  = (@{bypass="Logging,Metrics"; defaultAction="deny"}) # add ipRules and/or virtualNetworkRules
  EnableHttpsTrafficOnly = $true
}

New-AzStorageAccount @args

# Create storage account stgdemohttps
$sku = "Standard_LRS"
$kind = "StorageV2"
$accessTier = "Hot"

# ==> http traffic is allowed
$args = @{
  Name            = "stgdemohttps"
  Location        = $location
  SkuName         = $sku
  Kind            = $kind
  AccessTier      = $accessTier
  NetworkRuleSet  = (@{bypass="Logging,Metrics"; defaultAction="deny"}) # add ipRules and/or virtualNetworkRules
  EnableHttpsTrafficOnly = $false
}

New-AzStorageAccount @args

# Create storage account stgdemonetwork
$sku = "Standard_LRS"
$kind = "StorageV2"
$accessTier = "Hot"

# ==> missing network rule set
$args = @{
  Name            = "stgdemonetwork"
  Location        = $location
  SkuName         = $sku
  Kind            = $kind
  AccessTier      = $accessTier
  EnableHttpsTrafficOnly = $true
}

New-AzStorageAccount @args

# List your storage accounts
Get-AzStorageAccount -ResourceGroupName $rgName
