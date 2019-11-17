# Remove the demo resource group

$subscriptionName = "Visual Studio Enterprise"
$rgName = "rg-euw-meetup-demo"

# Login
if (!(Get-AzContext)) {
  Connect-AzAccount
  Set-AzContext -Subscription $SubscriptionName | Out-Null
}

# Remove a resource group
Remove-AzResourceGroup -Name $rgName
