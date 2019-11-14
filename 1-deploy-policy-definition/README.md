# Deploy a policy definition using Powershell

Examine the script:

- Connect-AzAccount
- Set-AzContext -Subscription
- Set-AzPolicyDefinition

Note that the policy definition will be added to a management group or to subscription. 
It cannot be assigned above it's location in the tree of management groups and subscriptions.

Trigger a scan:
`POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{YourRG}/providers/Microsoft.PolicyInsights/policyStates/latest/triggerEvaluation?api-version=2018-07-01-preview`

TODO: Add Policy assignment  
TODO: Add example rest call to trigger scan  
TODO: Take a look at the results of the policy  
TODO: Provide Terraform template to create a few storage accounts for policy testing.
