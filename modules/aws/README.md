# AWS Terraform modules

This directory contains all the AWS Terraform modules.

## Modules

- [`core`](core/README.md)
- [`eks-global`](eks-global/README.md)
- [`eks`](eks/README.md)
- [`irsa`](irsa/README.md)

## Style Guide

This section covers AWS specific standards that all modules should try to follow to decrease the risk of annoying problems in the future, and to guide
new contributors in how resources should be named. Any changes to this guide should be done together with updating the Terraform.

### Names and tags

A quirk of AWS is that there are some resources that are global and other that are regional. On top of that there are resources that get automatically
generated IDs and others that use the given name as a unique ID. That name may either have to be unique within the account or across all AWS accounts
in all regions.

Global resources with unique names:
* IAM Roles
* IAM Policy
* S3 Bucket

Regional resources with unique names:
* EKS Clusters

Any resource that has a generated ID should have tags to distinguish the resources between each other. The following tags should be added to all
resources of this kind. Try to make sure that the values are unique enough that there is no overlap.

| Tag | Required | Description |
| --- | --- | --- |
| Name | Yes | Name of the resource, try to convey the purpose or use. |
| Environment | Yes | Environment the resource is deployed in. |
| Module | Yes | The name of the Terraform module which has created the resource. |
| Cluster | No | If the resources is specific to an EKS cluster the cluster name should be entered here. |
| Application | No | Name of the application the resource may be tightly linked to. |

Resources that are global and require unique names should contain enough unique components to mitigate any name conflicts caused by multi region
deployments. This is especially important for IAM resources. On top of this the resources should also include the tags according to the standard above
but without the name. IAM resources should follow the same naming convention to reduce confusion and mitigate future issues. Keep in mind when naming
things that the name limit of IAM resources is 128 characters. Each IAM resource should follow the same convention, starting with a name prefix, the
region, and the environment.

```
<name-prefix>-<aws-region>-<environment>-<resource-name>

or

<name-prefix>-<aws-region>-<environment>-<resource-name><instance-id>
```

For S3 buckets its is a good idea to use the same naming convention but also include the `unique_suffix` to make sure that there are no other conflicts.

```
<name-prefix>-<aws-region>-<environment>-<resource-name>-<unique-suffix>
```

Lastly resources that are regional but require a unique name should include the environment in the name.

```
<resouce-name><instance-id>-<environment>
```
