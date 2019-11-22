# Deploy a policy definition, and assign these policy definitions using Powershell

Deploy two policy definition to your subscription. 
Use scripts 'New-PolicyStorageHttpsEnabled.ps1' and 'New-PolicyStorageNetworkAclsDeny.ps1'.

- Review the scripts
- Run the scripts
- Verify that your resource group is now subject to the policy

## Notes

[Recommendations for managing policies](https://docs.microsoft.com/en-us/azure/governance/policy/overview#recommendations-for-managing-policies)  
(The policies in this example are *not* grouped in an initiative, for simplicity)

The policies folder on GitHub and in this exercise is structured 'by Azure resource'.

A policy definition can be added to a management group or to subscription.  
A policy cannot be assigned 'above' it's location in the tree of management groups and subscriptions.

If you want deploy policies and initiatives using a pipeline, check out <https://blog.tyang.org/2019/05/19/deploying-azure-policy-definitions-via-azure-devops-part-1/>.
