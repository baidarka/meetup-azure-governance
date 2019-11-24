# Deloy a Blueprint

## Add a Blueprint

In the Azure Portal:  

- Search for 'Blueprints'
- Click 'Create'
- Select CAF Blueprint (Cloud Adoption Framework)
- Give a 'Name' and a 'Definition location' (select your Management Group or Subscription)
- (optional: Customize you Blueprint)
- Publish your Blueprint
- (optional: Assign your Blueprint to your subscription)

## Export a Blueprint

- (register resource provider 'Microsoft/Blueprint' for your target subscription)
- Get the Azure Powershell Blueprint module if needed: `Install-Module -Name Az.Blueprint`
- Get the names of your Blueprints: `get-azblueprint | select name`  
- Get Blueprint object, e.g.: `$bp = get-azblueprint -managementgroupid [yourMgmtGrpId] -name [yourBpName]`
- Get Blueprint artifacts, e.g.: `get-azblueprintartifact`
- Export Blueprint artifacts `export-azblueprintwithartifact -Blueprint $bp -OutputPath c:/temp/bp`  
  Review the files in the resulting folder structure
- Add your Blueprint to source control  
- Adapt to your companies requirements / policy-mapping / taste; import and assign


Read more...  
<https://docs.microsoft.com/en-us/azure/governance/blueprints/>  
<https://docs.microsoft.com/en-us/azure/governance/blueprints/samples/caf-foundation/>  
<https://github.com/Azure/azure-blueprints/blob/master/README.md>
