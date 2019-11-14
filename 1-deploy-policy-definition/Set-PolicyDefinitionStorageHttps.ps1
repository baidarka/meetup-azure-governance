[CmdletBinding()]
param (
    [Parameter (Mandatory=$false)]
    [string]$SubscriptionName = "Visual Studio Enterprise"
)

# https://docs.microsoft.com/en-us/azure/governance/policy/samples/ensure-https-storage-account
# Get-Module -ListAvailable Az

#####################
if (!(Get-AzContext)) {
    Connect-AzAccount
    Set-AzContext -Subscription $SubscriptionName | Out-Null
}

Write-Verbose ("Subscription: '{0}'" -f (Get-AzContext).Subscription.Name)

# note: a policy definition can be added to a management group or a subscription.
$args = @{
    Name         = "https-traffic-only"
    DisplayName  = "Ensure https traffic only for storage account"
    Description  = "Ensure https traffic only for storage account"
    Subscription = (Get-AzContext).Subscription.Name
    Policy       = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/https-traffic-only/azurepolicy.rules.json"
    Parameter    = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/https-traffic-only/azurepolicy.parameters.json"
    Mode         = "All"
}

$definition = New-AzPolicyDefinition @args
$definition
# $assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
# $assignment