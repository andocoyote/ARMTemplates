// To deploy:
// az deployment sub create --name GroupDeployment --location westus3 --parameters resource_group_parameters.bicepparam
// az deployment sub create -n GroupDeployment -l westus3 -p resource_group_parameters.bicepparam

using './/resource_group.bicep'

param resourceGroupName = 'MyResourceGroup'