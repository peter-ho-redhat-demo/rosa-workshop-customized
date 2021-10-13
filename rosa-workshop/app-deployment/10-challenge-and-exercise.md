## Time to practice and challenge yourself!

You have completed the Part 2 of this workshop! Congratulations! 

Before we end, we challenge you to deploy a Python application down below, but without any step-by-step guide or instructions! This is a very good chance to really practice what you have learn in this part of module. Most of the topics in this challege were being covered, so no worries. 

In case you are not able to do it, or encounter any issues or questions, you can always raise your hand and let the instructor know.

### Challenge requirement

1. Deploy this Python application (https://github.com/peter-ho-redhat-demo/rosa-workshop-customized-challenge) inside an OpenShift project called `<your-user-id>-challenge`.
    -  This Python application only runs on the version of `Python 3.6`.
    -  This Git repo does not come with any Dockerfile, you have to deploy the app without writing any Dockerfile.
    -  Set the name to `blog-django-py`.

2. Inside the same OpenShift project, create a PostgreSQL database (need to persist data, not ephemeral) with the following settings:
    - Name: `blog-database`
    - Username: `sampledb`
    - Password: `sampledb`
    - DB name: `sampledb`

3. Expose the Python application using TLS termination.
    - Meaning that we will need to access the app via HTTPS, not HTTP.
    - Test out the Python application to see what is the interim result.

4. By default, the Python application will retrive blog data in a local database that sits inside the same container. Now, we need to configure the Python application to use the PostgreSQL database that we have created for storage.
    - The Python application has been coded with a logic to check again an Environment Variable. If the environment variable `DATABASE_URL` exist, then it will connect to that DB instead of the local one.
    - You may use the following value for the `DATABASE_URL`:

            postgresql://sampledb:sampledb@blog-database:5432/sampledb
            
    - Test out the Python application to see if the blog content has been changed. If changed, that means the app is now pointing to the PostgreSQL DB.

5. Configure and mount a new AWS EBS to the Python application via Kubernetes / OpenShift dynamic volume provisioing.
    - The Python blog app allow users to upload image. However, as we did not mount any AWS EBS storage to it, any images uploaded are not persist when the app restarts.
    - Use the following configs:
        - Storage class: `gp2`
        - Access mode: `RWO`
        - Size: `1 GiB`
        - Volume mode: `File system`
        - Mount path: `/opt/app-root/src/media`

6. Configure environment variable in the Python app to change the website's appreance:
    - Set a variable with a key=`BLOG_SITE_NAME` and with a value=`ROSA Workshop Rocks!`
    - Visit the Python app again. Check out the title changes.