@description('Azure region for the App Service resources.')
param location string = resourceGroup().location

@description('Globally unique App Service site name.')
param appName string = 'crossfitmentalis'

@description('Name of the Linux App Service Plan.')
param planName string = 'crossfitmentalis-plan'

@description('Tags applied to all resources created by this deployment.')
param tags object = {
  workload: 'crossfit-mentalis-website'
  managedBy: 'bicep'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: planName
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  tags: union(tags, {
    'azd-service-name': 'crossfitmentalis'
  })
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: appName
  location: location
  kind: 'app,linux,node'
  tags: union(tags, {
    'azd-service-name': 'crossfitmentalis'
  })
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      appCommandLine: 'node server.js'
      alwaysOn: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      http20Enabled: true
    }
  }
}

output appName string = webApp.name
output defaultHostName string = webApp.properties.defaultHostName
output appServicePlanId string = appServicePlan.id
