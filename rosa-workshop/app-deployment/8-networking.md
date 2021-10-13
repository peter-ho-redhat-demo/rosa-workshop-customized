## Implementing TLS termination

In this section, we will configure OpenShift Route to implement TLS termination to enable your applications to be accessed via HTTPS. To begin, let's review how this application is set up.

![OSToy Diagram](images/3-ostoy-arch.png)

As can be seen in the image above, we have defined at least 2 separate pods, each with its own service.  One is the frontend web application (with a service and a publicly accessible route) and the other is the backend microservice with a service object so that the frontend pod can communicate with the microservice (across the pods if more than one).  Therefore this microservice is not accessible from outside this cluster. The sole purpose of this microservice is to serve internal web requests and return a JSON object containing the current hostname (which is the podname) and a randomly generated color string.

In order for users to access the frontend web application, OpenShift exposes something called a Route to make the applicaiton be available in a URL (the subdomain is pre-configured by OpenShift cluster administartor). Right now, the traffic uses HTTP. In order to make it HTTPS without changing your application code, we can instruct OpenShift to terminate the HTTPS TLS communication when the traffic arrives OpenShift router, and use back HTTP within OpenShift cluster.

### 1. Delete the existing OpenShift Route

Go back to your OpenShift web console, and select the Developer view. On the left, click `Search`.

In the first drop-down menu (i.e. somewhere with a text `Resources`) under the search section, click it and search `Route`. Select `Route`.

Click the `Add to navigtion` on the right to make the shortcut available on the menu on the left.

Right now, there is an existing Route object created (which was created when we apply YAMLs few labs back). Click to `vertical ...` icon right next to the Route row. Click `Delete Route`.

Confirm the deletion.

Try to access your OSToy application again using the URL that we have previously. You should now NOT able to enter the app because we have deleted the entrace.

### 2. Create a new OpenShift Route with TLS termination

Now, we are going to add the entrace back, but with TLS termination. Back to the OpenShift web console, under the Route page, click `Create Route` button.

Input the followings:

- Name: `ostoy-route`
- Service: `ostoy-frontend-svc` (make sure you don't select the wrong one)
- Target port: `8080 -> ostoy-port (TCP)`
- Security: Check the `Secure Route` box
- TLS termination: Edge

Then click `Create` button.

### 3. Verify the result

Once created, you will notice that you will be redirected to the Route object page. On the right, you will find the URL, but this time with HTTPS.

Click the URL.

Notice that you are accessing the webpage via HTTPS. You can confirm that by looking at the lock icon in your brower's address bar.

Congrats! Now your application is secured and prevent man-in-the-middle attack using TLS communication encryption!