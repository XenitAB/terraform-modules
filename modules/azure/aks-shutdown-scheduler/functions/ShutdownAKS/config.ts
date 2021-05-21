import { IsEmpty } from "./utils"
import { Context } from "@azure/functions"

export type Config = {
    subscriptionId: string;
    resourceNameFilter: string;
}

export const Generate = (context: Context): Config | null => {
    const subscriptionId = process.env["AZURE_SUBSCRIPTION_ID"]
    const resourceNameFilter = process.env["AZURE_RESOURCE_NAME_FILTER"]

    if (IsEmpty(subscriptionId)) {
        context.log("[CONFIG] Environment variable for subscriptionId [AZURE_SUBSCRIPTION_ID] can't be empty")
        return null
    }

    if (IsEmpty(resourceNameFilter)) {
        context.log("[CONFIG] Environment variable for resourceNameFilter [AZURE_RESOURCE_NAME_FILTER] can't be empty")
        return null
    }

    return {
        subscriptionId,
        resourceNameFilter
    }
}