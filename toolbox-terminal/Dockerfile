FROM registry.access.redhat.com/ubi8/ubi@sha256:910f6bc0b5ae9b555eb91b88d28d568099b060088616eba2867b07ab6ea457c7

RUN yum install zip unzip ncurses glibc less -y

RUN dnf install groff-base -y 

RUN useradd -u 8877 rosauser

RUN chgrp -R 0 /home/rosauser && \
    chmod -R g=u /home/rosauser

RUN chown -R rosauser /usr/local/

USER rosauser

WORKDIR /home/rosauser/

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -b /usr/local/bin

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

RUN rm -r /home/rosauser/*

ENV HOME=/home/rosauser

CMD /bin/bash