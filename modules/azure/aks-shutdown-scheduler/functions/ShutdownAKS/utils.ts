export const GetResourceGroupNameFromClusterId = (clusterId: string): string => {
    const resourceGroupName = clusterId.split("/")[4]
    return resourceGroupName
}

export const IsEmpty = (input: string): boolean => {
    if (!input) {
        return true
    }

    if (!input.trim().length) {
        return true
    }

    return false
}