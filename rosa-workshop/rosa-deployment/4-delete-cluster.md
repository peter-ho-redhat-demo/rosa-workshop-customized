## Deleting a ROSA Cluster

To delete a ROSA cluster follow the steps below.

1. Run the following:

		rosa delete cluster --cluster=<your-user-id>-rosa --watch

1. It will prompt you to confirm that you want to delete it. Press “y” then enter. The cluster will be deleted and all its associated infrastructure. **THIS IS NON-RECOVERABLE.**

Now the cluster has been deleted! Congratulations! You have completed the part 1 of this workshop! You have learnt how to deploy a ROSA cluster from stretch using ROSA, AWS and oc commands.
 
## Bonus topic - Deleting the AWS STS/IAM roles that we have created

This is a bouns part of the workshop. You do NOT have to complete these. However, please feel free to read it if you are interested. For more information, check out the ROSA documentation: https://docs.openshift.com/rosa/rosa_getting_started_sts/rosa-sts-deleting-cluster.html.

> Note: All AWS STS/IAM roles and policies will remain and must be deleted manualy once the cluster deletion is complete.

1. Once the ROSA cluster deletion complete, you may then delete the:
	* Cluster roles
	* Policies
	* OIDC Providers

	This can be done via the `aws` CLI or from the AWS web console. These can be found under IAM > Roles or Policies or Identity providers > search for your cluster name.

	![mp](images/12-del_cr.png)

1. The remaining roles would be account-scoped and should only be removed if they are <u>no longer needed by other clusters in the same account</u>. To delete these search for "ManangedOpenShift" or your specified prefix (if specified).