# Deploy a policy definition using Powershell

Deploy a policy defnition an assign it to the demo resource group.

- review the script New-PolicyStorageHttps.ps1
- run the script
- verify that your resource group is now subject to the policy

Note that a policy definition can be added to a management group or to subscription.  
It cannot be assigned above it's location in the tree of management groups and subscriptions.
