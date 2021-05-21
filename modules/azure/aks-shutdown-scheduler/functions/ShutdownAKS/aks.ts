import { Context } from "@azure/functions"
import * as AzureAuth from "@azure/ms-rest-nodeauth"
import { ContainerServiceClient, ContainerServiceModels } from "@azure/arm-containerservice"
import * as Utils from "./utils"
import * as Config from "./config"

export const ShutdownClusters = async (context: Context, config: Config.Config): Promise<boolean> => {
    const credential = await newCredential()
    const client = newClient(credential, config.subscriptionId)
    const clusters = await listClusters(client)
    const onlineClusters = filterOnlineClusters(clusters)
    const filteredClusters = filterClusterNames(onlineClusters, config.resourceNameFilter)

    if (isEmpty(filteredClusters)) {
        context.log("[AKS] No online clusters found", { config, filteredClusters })
        return true
    }

    const result = await shutdownClusters(client, filteredClusters)
    if (!result) {
        context.log("[AKS] Unable to shutdown clusters", { config, filteredClusters })
        return false
    }

    context.log("[AKS] Successfully shutdown clusters", { config, filteredClusters })

    return true
}

const newCredential = async (): Promise<AzureAuth.AzureCliCredentials> => {
    const credential = await AzureAuth.AzureCliCredentials.create()
    return credential
}

const newClient = (credentials: AzureAuth.AzureCliCredentials, subscriptionId: string): ContainerServiceClient => {
    const client = new ContainerServiceClient(credentials, subscriptionId)
    return client
}

const listClusters = async (client: ContainerServiceClient): Promise<ContainerServiceModels.ManagedClustersListResponse> => {
    const clusters = await client.managedClusters.list()
    return clusters
}

const filterOnlineClusters = (clusters: ContainerServiceModels.ManagedClustersListResponse): ContainerServiceModels.ManagedCluster[] => {
    const onlineClusters = clusters.filter(cluster => cluster.powerState.code == "Running")
    return onlineClusters
}

const filterClusterNames = (clusters: ContainerServiceModels.ManagedCluster[], filter: string): ContainerServiceModels.ManagedCluster[] => {
    const filteredClusters = clusters.filter(cluster => cluster.name.includes(filter))
    return filteredClusters
}

const isEmpty = (clusters: ContainerServiceModels.ManagedCluster[]): boolean => {
    const onlineClusters = clusters.filter(cluster => cluster.powerState.code == "Running")
    const numOnlineClusters = onlineClusters.length
    return numOnlineClusters === 0
}

const shutdownClusters = async (client: ContainerServiceClient, clusters: ContainerServiceModels.ManagedCluster[]): Promise<boolean> => {
    const statuses = await Promise.all(
        clusters.map(async cluster => {
            const resourceGroup = Utils.GetResourceGroupNameFromClusterId(cluster.id)
            const response = await client.managedClusters.stop(resourceGroup, cluster.name)
            return response._response.status
        }))

    const non200Statuses = statuses.filter(s => s !== 200).length

    return non200Statuses !== 0
}
