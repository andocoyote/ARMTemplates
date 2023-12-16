// To deploy:
// az deployment group create --name IPAddressDeployment --resource-group MyResourceGroup --parameters ipaddress_dynamic_parameters.bicepparam
// az deployment group create -n IPAddressDeployment -g MyResourceGroup -p ipaddress_dynamic_parameters.bicepparam

using './/ipaddress_dynamic.bicep'

param IPAddressName = 'gateway-pip'