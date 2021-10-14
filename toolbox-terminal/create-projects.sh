#!/bin/bash

# Create project and deploy the toolbox
# for i in {1..50}
# do
#    oc new-project user$i-rosa-workshop-toolbox
#     oc process -f toolbox-setup-template.yaml -p USERNAME=user$i | oc apply -f -
# done

# Add AWS credentials file
for i in {1..50}
do
    oc project user$i-rosa-workshop-toolbox
    oc set env deployment/rosa-workshop-toolbox-terminal \
        USER_ID=user$i \
        AWS_ACCESS_KEY=XXX \
        AWS_SECRET_KEY=XXX \
        ROSA_INSTALL_TOKEN=XXX
done