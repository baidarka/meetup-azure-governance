# Deloy a Blueprint

## (optional) Add a Management Group if you do not have one

- Open the Azure portal
- Search for 'Management Groups'
- Add Management Group (enter display name and a GUID)
- Open your Management Group, select 'Add subscription'

## Add a Blueprint

- (register resource provider 'Microsoft/Blueprint' for your target subscription)
- Search for 'Blueprints'
- Click 'Create'
- Select CAF Blueprint
- Give a 'Name' and a 'Definition location' (select your Management Group or Subscription)
- Publish your Blueprint
- Assign your Blueprint