# Meetup Azure Governance

Hands-on modules for the Dutch Azure Meetup on Governance.  
*Disclaimer: these exercises will create several Azure resources and may cost you some money.*

These modules are based on PowerShell (Az module). See 'Tools' below.  
(You may also want to look into azure-cli, and the [ArmClient](https://www.github.com/projectkudu/ARMClient).)

## Getting started

Conjure up a resource group with some storage accounts: [Add demo environment](1-add-demo-environment/).

## Module story

To implement your company's Cloud policy, you map each requirement to a control on an Azure resource. This typically leads to   [deployment and assignment of policies](2-deploy-policy-definition/). If you want to deploy a _complete_ policy definition (combination of metadata, rule and parameter), then have a look at the ARMClient.

Microsoft recommends to bundle policies in 'policy sets' called 'Initiatives'. Unlike Powershell, the Azure CLI allows to **update** Initiatives.

When creating custom policies the [VSCode Policy Extension](3-VSCode-policy-extension/) proves helpful.  

Policy evaluations may take quite some time. Have a go at this by [triggering a policy evaluation](4-trigger-policy-evaluation/) yourself. While you're at it, grab the policy evaluation results.

Policies may include remediation tasks. While remediation is a powerful concept, options a still quite specific. (skip this module, it is unfinished).

When setting up an environment or subscription, you may want to include your policies in a Blueprint. [Explore a blueprint](6-explore-blueprint/) to get inspired!

Lastly, take advantage of the Azure DevOps release Gate 'Policy' to ensure releasing to a compliant environment.

## Clean up

When done: [tidy up](7-remove-demo-environment/).

## Tools

- [GIT](https://git-scm.com/)
- [VSCode](https://code.visualstudio.com/)
  - Azure Policy
  - GitLens
  - Markdownlint
  - Powershell
- [Powershell](https://github.com/PowerShell/PowerShell)
  - [Powershell Az module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az?view=azps-3.0.0)

## Contributors

Thanks to Bas Kortleven (Wolf & Cherry) and Bram Kleverlaan (OahPat) for inspiration!s