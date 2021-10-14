FROM registry.access.redhat.com/ubi8/ubi@sha256:910f6bc0b5ae9b555eb91b88d28d568099b060088616eba2867b07ab6ea457c7

RUN dnf install zip unzip ncurses glibc less groff-base -y

# Make a temp install folder
RUN mkdir /tmp/installation

WORKDIR /tmp/installation

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

RUN curl "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/latest/rosa-linux.tar.gz" -o "rosa-linux.tar.gz" && \
    tar -xf rosa-linux.tar.gz --no-same-owner && \
    chmod +x rosa && \
    mv rosa /usr/local/bin/rosa

RUN rosa download openshift-client && \
    tar -xf openshift-client-linux.tar.gz && \
    chmod +x kubectl && \
    chmod +x oc && \
    mv kubectl /usr/local/bin/kubectl && \
    mv oc /usr/local/bin/oc

WORKDIR /

# Delete the temp install folder
RUN rm -rf /tmp/installation

RUN useradd -u 10001 user

# OpenShift run as arbitrary user which in root group, need to make the home directory writeable
RUN chgrp -R 0 /home/user && \
    chmod -R g=u /home/user

USER 10001

WORKDIR /home/user/

ENV HOME=/home/user

CMD /bin/bash