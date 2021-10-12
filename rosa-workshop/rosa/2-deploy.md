There are two ways to deploy a cluster with STS mode. One is automatic, which is quicker and will do the manual work for you. The other is manual, which will require you to execute some extra commands, but will allow you to inspect the roles and policies being created. If you just want to get your cluster created quickly, please use the automatic section, but if you would rather explore the objects being created then feel free to use manual. This is achieved via the `--mode` flag in the relevant commands.

Valid options for `--mode` are:

- **manual:** Role and Policy documents will be created and saved in the current directory. You will need to manually run the commands that are provided  as the next step.  This will allow you to review the policy and roles before creating them.
- **auto:** Roles and policies will be created and applied automatically using the current AWS account, instead of having to manually run each command.

>**Note:** If no mode is selected the **auto** mode is the default.

In this workshop, we will be using the automatic mode as that is quicker and has less steps.

## Deployment flow
The overall ROSA deployment flow that we will follow boils down to 4 (but really 3) steps.

1. `rosa create account-roles` - This is executed only <u>once</u> per account, per OpenShift version. Once created, this does *not* need to be executed again for more clusters of the same version. <u>We will NOT be running this command as we have ran this command in your AWS account before we start this workshop.</u>. This is just for your information.
1. `rosa create cluster`
1. `rosa create operator-roles`
1. `rosa create oidc-provider`

For each succeeding cluster in the same account for the same version, only steps 2-4 are needed.

## Automatic Mode
As mentioned above if you want the ROSA CLI to automate the creation of the roles and policies to create your cluster quickly, then use this method.

### Create account roles (JUST READ this section, we have done this for you already)
If this is the <u>first time</u> you are deploying ROSA in this account and have <u>not yet created the account roles</u> for the OpenShift version you are deploying, then enable ROSA to create JSON files for account-wide roles and policies, including Operator policies. 

Run the following command (to see all available OpenShift versions available run: `rosa list versions`):

    rosa create account-roles --mode auto --version 4.8 --yes

You will see an output like the following:

    I: Creating roles using 'arn:aws:iam::000000000000:user/rosa-user'
    I: Created role 'ManagedOpenShift-ControlPlane-Role' with ARN 'arn:aws:iam::000000000000:role/ManagedOpenShift-ControlPlane-Role'
    I: Created role 'ManagedOpenShift-Worker-Role' with ARN 'arn:aws:iam::000000000000:role/ManagedOpenShift-Worker-Role'
    I: Created role 'ManagedOpenShift-Support-Role' with ARN 'arn:aws:iam::000000000000:role/ManagedOpenShift-Support-Role'
    I: Created role 'ManagedOpenShift-Installer-Role' with ARN 'arn:aws:iam::000000000000:role/ManagedOpenShift-Installer-Role'
    I: Created policy with ARN 'arn:aws:iam::000000000000:policy/ManagedOpenShift-openshift-machine-api-aws-cloud-credentials'
    I: Created policy with ARN 'arn:aws:iam::000000000000:policy/ManagedOpenShift-openshift-cloud-credential-operator-cloud-crede'
    I: Created policy with ARN 'arn:aws:iam::000000000000:policy/ManagedOpenShift-openshift-image-registry-installer-cloud-creden'
    I: Created policy with ARN 'arn:aws:iam::000000000000:policy/ManagedOpenShift-openshift-ingress-operator-cloud-credentials'
    I: Created policy with ARN 'arn:aws:iam::000000000000:policy/ManagedOpenShift-openshift-cluster-csi-drivers-ebs-cloud-credent'
    I: To create a cluster with these roles, run the following command:
    rosa create cluster --sts


### Create the cluster
Run the following command to create a cluster with all the default options (except that we specify the ROSA cluster should be deployed in multiple availabilty zones and with 3 compute worker nodes spread across zones). For the cluster name, <b><u>you must use the cluster name that was given by the workshop instructor (the AWS account is shared across multiple participants, please use the name we provide to avoid naming conflict)</u></b>.

    rosa create cluster --cluster-name <cluster name> --multi-az --compute-nodes 3 --sts

>**Note:** If you want to see all available options for your cluster use the `--help` flag or for interactive mode you can use `--interactive`

For example: 

    $ rosa create cluster --cluster-name my-rosa-cluster --multi-az --compute-nodes 3 --sts

You should see a response like the following:

    I: Creating cluster 'my-rosa-cluster'
    I: To view a list of clusters and their status, run 'rosa list clusters'
    I: Cluster 'my-rosa-cluster' has been created.
    I: Once the cluster is installed you will need to add an Identity Provider before you can login into the cluster. See 'rosa create idp --help' for more information.
    I: To determine when your cluster is Ready, run 'rosa describe cluster -c my-rosa-cluster'.
    I: To watch your cluster installation logs, run 'rosa logs install -c my-rosa-cluster --watch'.
    Name:                       my-rosa-cluster
    ID:                         1mlhulb3bo0l54ojd0ji000000000000
    External ID:                
    OpenShift Version:          
    Channel Group:              stable
    DNS:                        my-rosa-cluster.ibhp.p1.openshiftapps.com
    AWS Account:                000000000000
    API URL:                    
    Console URL:                
    Region:                     ap-southeast-1
    Multi-AZ:                   true
    Nodes:
     - Master:                  3
     - Infra:                   3
     - Compute:                 3
    Network:
     - Service CIDR:            172.30.0.0/16
     - Machine CIDR:            10.0.0.0/16
     - Pod CIDR:                10.128.0.0/14
     - Host Prefix:             /23
    STS Role ARN:               arn:aws:iam::000000000000:role/ManagedOpenShift-Installer-Role
    Support Role ARN:           arn:aws:iam::000000000000:role/ManagedOpenShift-Support-Role
    Instance IAM Roles:
     - Master:                  arn:aws:iam::000000000000:role/ManagedOpenShift-ControlPlane-Role
     - Worker:                  arn:aws:iam::000000000000:role/ManagedOpenShift-Worker-Role
    Operator IAM Roles:
     - arn:aws:iam::000000000000:role/my-rosa-cluster-openshift-image-registry-installer-cloud-credentials
     - arn:aws:iam::000000000000:role/my-rosa-cluster-openshift-ingress-operator-cloud-credentials
     - arn:aws:iam::000000000000:role/my-rosa-cluster-openshift-cluster-csi-drivers-ebs-cloud-credentials
     - arn:aws:iam::000000000000:role/my-rosa-cluster-openshift-machine-api-aws-cloud-credentials
     - arn:aws:iam::000000000000:role/my-rosa-cluster-openshift-cloud-credential-operator-cloud-credential-oper
    State:                      pending (Preparing account)
    Private:                    No
    Created:                    Aug 18 2021 20:28:09 UTC
    Details Page:               https://console.redhat.com/openshift/details/s/1wupmiQy45xr1nN000000000000
    OIDC Endpoint URL:          https://rh-oidc.s3.us-east-1.amazonaws.com/1mlhulb3bo0l54ojd0ji000000000000

The default settings does not use multiple availability zones on AWS. If you do not specify `--multi-az` this flag, the ROSA will be deployed within a single availability zone with 3 master nodes, 2 infra nodes and 2 worker nodes. However, if you specify `--multi-az` like what you did, the ROSA cluster will evenly distribute all nodes across zones, and will by default create 3 master nodes, 3 infra nodes and 3 worker nodes.

>**NOTE:** This will take about 30-40 minutes to run. <b><u>(Note: You must complete the next steps to create the Operator IAM roles and the OpenID Connect (OIDC) provider before the cluster starts the actual installation, otherwise, it will always in the Pending state)</u></b>.

### Create operator roles
These roles need to be created <u>once per cluster</u>. To create the roles run the following:

    rosa create operator-roles --mode auto --cluster <cluster-name> --yes

### Create the OIDC provider
Run the following to create the OIDC provider:

    rosa create oidc-provider --mode auto --cluster <cluster-name> --yes

### Check installation status
1. You can run the following command to check the status of the cluster for a detailed view:

        rosa describe cluster --cluster <cluster-name>

    or you can also run the following for an abridged view of the status (since the AWS account that we give are shared by many participants, you will likely see other people's ROSA cluster when you run the command below):

        rosa list clusters

    You should notice the state change from “Pending” to “Installing”, and then wait for 30-40 minutes, it should be in the "Ready" state.
    
1. You can also rack the progress of the cluster creation by watching the OpenShift installer logs:

        rosa logs install --cluster <cluster_name> --watch

1. Once the state has changed to “Ready” your cluster is now installed.  

## Obtain the Console URL
Please wait around 30-40 minutes for the cluster to provision AWS resources and install the OpenShift cluster. Have a tea or coffee, come back later. Once it is done, get the console URL by running:

    rosa describe cluster -c <cluster-name> | grep Console

The cluster has now been successfully deployed.
