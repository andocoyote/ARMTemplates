// To deploy:
// az deployment group create --name VNetTestDeployment --resource-group MyResourceGroup --parameters virtualnetwork_frontend_backend_parameters.bicepparam
// az deployment group create -n VNetTestDeployment -g MyResourceGroup -p virtualnetwork_frontend_backend_parameters.bicepparam

using './/virtualnetwork_frontend_backend.bicep'

param virtualNetworkName = 'MyNetwork-vnet'
param frontendSubnetName = 'Frontend'
param backendSubnetName = 'Backend'

// Create 2 subnets, each with 255 possible addresses
param virtualNetworkRange = '10.1.0.0/23'
param frontendSubnetRange = '10.1.0.0/24'
param backendSubnetRange = '10.1.1.0/24'