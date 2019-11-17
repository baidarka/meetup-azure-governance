[CmdletBinding()]
param (
    [Parameter (Mandatory=$false)]
    [string]$SubscriptionName = "Visual Studio Enterprise",

    [Parameter (Mandatory=$false)]
    [string]$ResourceGroupName = "rg-euw-meetup-demo"
)

# https://docs.microsoft.com/en-us/azure/governance/policy/samples/ensure-https-storage-account
# Get-Module -ListAvailable Az

#####################
if (!(Get-AzContext)) {
    Connect-AzAccount
    Set-AzContext -Subscription $SubscriptionName | Out-Null
}

Write-Verbose ("Subscription: '{0}'" -f (Get-AzContext).Subscription.Name)

# Register the resource provider (if it's not already provided)
Register-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights'

# Get the id of the demo resource group
$rg = Get-AzResourceGroup -Name $ResourceGroupName

$polRules = Get-Content "./policy-storage-audit-https/azurepolicy.rules.json"

# note: a policy definition can be added to a management group or a subscription.
$args = @{
    Name         = "https-traffic-only"
    DisplayName  = "Ensure https traffic only for storage account"
    Description  = "Ensure https traffic only for storage account"
    Subscription = (Get-AzContext).Subscription.Id
    Policy       = "https://raw.githubusercontent.com/baidarka/meetup-azure-governance/master/2-deploy-policy-definition/policy-storage-audit-https/azurepolicy.rules.json"
    Parameter    = "https://raw.githubusercontent.com/baidarka/meetup-azure-governance/master/2-deploy-policy-definition/policy-storage-audit-https/azurepolicy.parameters.json"
    #Policy       = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/https-traffic-only/azurepolicy.rules.json"
    #Parameter    = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/https-traffic-only/azurepolicy.parameters.json"
    Mode         = "All"
}

$definition = New-AzPolicyDefinition @args
$definition

$args = @{
    Name                = "monitor-stg-https-traffic-only"
    Scope               = $rg.ResourceId
    PolicyDefinition    = $definition
}

$assignment = New-AzPolicyAssignment @args
$assignment

