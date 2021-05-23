import { AzureFunction, Context } from "@azure/functions"
import * as AKS from "./aks"
import * as Config from "./config"

const timerTrigger: AzureFunction = async function (context: Context, myTimer: any): Promise<void> {
    try {
        const config = Config.Generate(context)
        if (!config) {
            throw new Error("Unable to generate configuration")
        }

        const result = await AKS.ShutdownClusters(context, config)
        if (!result) {
            throw new Error("Unable to shutdown cluster")
        }

        context.res = {
            status: 200,
            body: "Successfully shutdown clusters"
        };
    } catch (err) {
        context.log(err)

        context.res = {
            status: 400,
            body: "Unable to shutdown clusters"
        };

        throw err
    }
}

export default timerTrigger
