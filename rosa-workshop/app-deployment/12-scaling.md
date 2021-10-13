## Scaling
OpenShift allows one to scale up/down the number of pods for each part of an application as needed.  This can be accomplished via changing our *replicaset/deployment* definition (declarative), by the command line (imperative), or via the web UI (imperative). In our *deployment* definition (part of our `ostoy-fe-deployment.yaml`) we stated that we only want one pod for our microservice to start with. This means that the Kubernetes Replication Controller will always strive to keep one pod alive. We can also define [autoscaling](https://docs.openshift.com/dedicated/4/nodes/pods/nodes-pods-autoscaling.html) based on load to expand past what we defined if needed which we will do in a later section of this lab.

If we look at the tile on the left we should see one box randomly changing colors. This box displays the randomly generated color sent to the frontend by our microservice along with the pod name that sent it. Since we see only one box that means there is only one microservice pod.  We will now scale up our microservice pods and will see the number of boxes change.

#### 1. Confirm number of pods running
To confirm that we only have one pod running for our microservice, run the following command, or use the web UI.


	$ oc get pods
	NAME                                   READY     STATUS    RESTARTS   AGE
	ostoy-frontend-679cb85695-5cn7x       1/1       Running   0          1h
	ostoy-microservice-86b4c6f559-p594d   1/1       Running   0          1h


#### 2. Scale pods via Deployment definition
Let's change our microservice definition yaml to reflect that we want 3 pods instead of the one we see. Download the [ostoy-microservice-deployment.yaml](https://raw.githubusercontent.com/openshift-cs/osdworkshop/master/OSD4/yaml/ostoy-microservice-deployment.yaml) and save it on your local machine, if you didn't do so already.

- Open the file using your favorite editor. Ex: `vi ostoy-microservice-deployment.yaml`
- Find the line that states `replicas: 1` and change that to `replicas: 3`. Then save and quit.

It will look like this:


	spec:
	    selector:
	      matchLabels:
	        app: ostoy-microservice
	    replicas: 3

- Assuming you are still logged in via the CLI, execute the following command:

		oc apply -f ostoy-microservice-deployment.yaml

>NOTE: (You could also change it directly in the OpenShift Web Console by going to Deployments > "ostoy-microservice" > "YAML" tab)

- Confirm that there are now 3 pods via the CLI (`oc get pods`) or the web UI (*Workloads > Deployments > ostoy-microservice*).
- See this visually by visiting the OSToy app > Autoscaling in the left menu and counting how many boxes there are now.  It should be three.

![UI Scale](images/8-ostoy-colorspods.png)

#### 3. Scale down via CLI
Now we will scale the pods down using the command line.  

- Execute the following command from the CLI: 

		oc scale deployment ostoy-microservice --replicas=2

- Confirm that there are indeed 2 pods, via the CLI or the web UI.

		oc get pods

- See this visually by visiting the OSToy app and counting how many boxes there are now.  It should be two.

#### 4. Scale down via web UI
Lastly, let's use the web UI to scale back down to one pod.  

- In the project you created for this app (ie: "ostoy") in the left menu click *Workloads > Deployments > ostoy-microservice*.  On the left you will see a blue circle with the number 2 in the middle. 
- Click on the down arrow to the right of that to scale the number of pods down to 1.

![UI Scale](images/8-ostoy-uiscale1.png)

- See this visually by visiting the OSToy app and counting how many boxes there are now.  It should be one.
- You can also confirm this via the CLI or the web UI




## Autoscaling

In this section we will explore how the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) (HPA) can be used and works within Kubernetes/OpenShift. See here for [cluster autoscaling](/rosa/8-autoscaling) in ROSA.

As defined in the Kubernetes documentation:
> Horizontal Pod Autoscaler automatically scales the number of pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization.

We will create an HPA and then use OSToy to generate CPU intensive workloads.  We will then observe how the HPA will scale up the number of pods in order to handle the increased workloads.  

#### 1. Create the Horizontal Pod Autoscaler

Run the following command to create the autoscaler. This will create an HPA that maintains between 1 and 10 replicas of the Pods controlled by the *ostoy-microservice* Deployment created. Roughly speaking, the HPA will increase and decrease the number of replicas (via the deployment) to maintain an average CPU utilization across all Pods of 80% (since each pod requests 50 millicores, this means average CPU usage of 40 millicores)

	oc autoscale deployment/ostoy-microservice --cpu-percent=80 --min=1 --max=10

#### 2. View the current number of pods

In the OSToy app in the left menu click on "Autoscaling" to access this portion of the workshop.  

![HPA Menu](images/12-hpa-menu.png)

As was in the networking section you will see the total number of pods available for the microservice by counting the number of colored boxes.  In this case we have only one.  This can be verified through the web UI or from the CLI.

You can use the following command to see the running microservice pods only:

	oc get pods --field-selector=status.phase=Running | grep microservice

or visually in our application:

![HPA Main](images/12-hpa-mainpage.png)

#### 3. Increase the load

Now that we know that we only have one pod let's increase the workload that the pod needs to perform. Click the link in the center of the card that says "increase the load".  **Please click only *ONCE*!**

This will generate some CPU intensive calculations.  (If you are curious about what it is doing you can click [here](https://github.com/openshift-cs/ostoy/blob/master/microservice/app.js#L32)).

> **Note:** The page may become slightly unresponsive.  This is normal; so be patient while the new pods spin up.

#### 4. See the pods scale up

After about a minute the new pods will show up on the page (represented by the colored rectangles). Confirm that the pods did indeed scale up through the OpenShift Web Console or the CLI (you can use the command above).

> **Note:** The page may still lag a bit which is normal.

#### 5. Review resources with monitoring

After confirming that the autoscaler did spin up new pods, switch to Grafana to visually see the resource consumption of the pods and see how the workloads were distributed.

We can also view the same information through the OpenShift Web Console by going through *Monitoring* > *Dashboards* in the left-hand menu.

![Dashboard](images/12-dashboard.png)


Or to use Grafana directly, go to the following url:

	https://grafana-openshift-monitoring.apps.<cluster-id>.<shard-id>.p1.openshiftapps.com

(e.g., https://grafana-openshift-monitoring.apps.demo-cluster.a1b2.p1.openshiftapps.com/)


Click on *General / Home* on the top left.

![Grafana](images/12-grafana-home.png)

Select the *Default* folder then *"Default / Kubernetes / Compute Resources / Namespace (Pods)"* dashboard.

![Select Dash](images/12-grafana-dash.png)

Click on *Namespace* and select our project name "ostoy".

![Select NS](images/12-grafana-ns.png)

Colorful graphs will appear showing resource usage across CPU and memory.  The top graph will show recent CPU consumption per pod and the lower graph will indicate memory usage.  Looking at this graph you can see how things developed. As soon as the load started to increase (A), three new pods started to spin up (B, C, D). The thickness of each graph is its CPU consumption indicating which pods handled more load.  We also see that after the load decreased, the pods were spun back down (E).

![CPU](images/12-grafana-cpu.png)

Mouse over the graph and the tool will display the names and corresponding CPU consumption of each pod as seen below.

![CPU](images/12-grafana-metrics.png)
