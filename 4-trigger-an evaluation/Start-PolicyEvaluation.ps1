<#
  .SYNOPSIS
  Trigger a policy evaluation and get the results.

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

$subId = (Get-AzSubscription -SubscriptionName $SubscriptionName).Id

# URI for Subscription and resource group.
$uri = ("https://management.azure.com/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.PolicyInsights/policyStates/latest/triggerEvaluation?api-version=2018-07-01-preview"-f $subId, $ResourceGroupName)

$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$token = $profileClient.AcquireAccessToken((Get-AzContext).Subscription.TenantId)

$headers = @{
    'Content-Type'  = "application/json" 
    'Authorization' = ("Bearer {0}"-f $token.AccessToken)
}

# Post a trigger ##############################################################
Write-Verbose "Post an evaluation trigger..."
$response = Invoke-WebRequest -Uri $uri -Method POST -Headers $headers

if ($response.StatusCode -ne 202) {
    Write-Error "Oops"  #  Of zoals Ro zegt: "Handjes in de lucht en gillen maar!"
    exit 1
}
$locationUri = $response.Headers.Location[0]
Write-Verbose -Message ("Location uri: '{0}'." -f $locationUri)

# Wait for the eval to complete ###############################################
$idx = 1
$maxRetries = 30
$sleep = 15
while ((($response = Invoke-WebRequest -Uri $locationUri -Method GET -Headers $headers).StatusCode -ne 200) `
        -AND ($idx -lt $maxRetries)) {
    Write-Verbose ("Request {0} returned status code {1}, retrying..." -f $idx, $response.StatusCode)
    Start-Sleep $sleep
    $idx++
}

if ($response.StatusCode -ne 200) {
    $reponse
    Write-Error "Response statuscode not 200 and retries exhausted."
    exit 1
}
Write-Output "Policy evaluation completed!"

# Get the policy compliance summary ###########################################
Get-AzPolicyState -SubscriptionId $subId -ResourceGroupName $ResourceGroupName | where { $_.IsCompliant -eq $false } 

Get-AzPolicyStateSummary -SubscriptionId $subId -ResourceGroupName $ResourceGroupName