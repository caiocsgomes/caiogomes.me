---
title: "Kubernetes: verifying container's health"
date: 2024-04-16T11:18:00-03:00
slug: "kubernetes-verifying-containers-health" # The unique identifier of the post in the URL, if you place a new slug the URL will change, i this case it would be https://caiogomes.me/posts/here-you-will-place-the-slug-of-the-post/
category: kubernetes # The category of the post, it will be used to group posts in the same category. Not using for now
description: "In this post we will talk about how to verify if a container is healthy in Kubernetes"
draft: false
---

## Introduction
In this post we will try to understand how to check if a container is healthy and what are the methods and patterns available in kubernetes to do so.
Besides that, we will also understand the patterns kubernetes provides and when to use each of them, the patterns are *process health check*, *liveness probe*, *readiness probe* and *startup probe*.
In summary, when trying to check the health of a container, we are trying to find the best method to allow kubernetes to verify if the application is running correctly. 

## Methods to check container health
In the basics of kubernetes we have applications running in containers, so we need to check if the application is healthy inside the container.
The application needs to provide a way to be healthy checked, for instance, a web server would provide a health check endpoint to be ckecked with *HTTP*,
a database would provide a way to be checked with *TCP* usually, in a sidecar container that generates a file we could check if the file is being generated with a *command*.
The container provides a way to run different types of applications and we need to understand what method works best for the application we are running and use it.

## Process health check
This is the default health check that the kubelet uses to verify if the container in the pod is healthy. What it does is to check if the process is running inside all the pod's containers.
If the process is not running or has exited with a non-zero status the kubelet will restart the container. 

Whenever we use a health check we need to think if the process health check is enough for our application. 
For instance, if we are running a web server, the process health check is not enough, as the process could be running but the server could be down and not responding to requests.
Another example would be if we have a code error that makes the container crash, in this case the process health check won't be enough too.
On the other hand, if the application is capable of detecting a fail and shutting down the process, the process health check may be enough.

## Liveness probe
Using the liveness probe the kubelet checks the container health from time to time and restarts the container if it's not healthy. The difference from the process health check is that
it uses the custom methods available in kubernetes to check the container health, like *HTTP*, *TCP* and *command*. Another advantage is we can specify the time behaviour when checking,
like the initial delay, the period and the timeout.

The liveness probe is useful when restarting the container probably fixes the issue, like a deadlock. Keep in mind that if restarting the container does not fix the issue,
the liveness probe has no value, as it will restart the container in a loop but the problem will persist.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: liveness-example
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 15
      timeoutSeconds: 2
      periodSeconds: 5
      failureThreshold: 3
```

## Readiness probe
In some scenarios what an application needs not to be restarted, but to be given more time to become ready, for instance, when the application is waiting to create a dataset,
to load a configuration file or to connect to an external system. In this case we use the readiness probe, that checks if the application is ready to receive traffic.
The parameters passed to it are the same as the liveness probe, but the corrective action is different. The kubelet will not restart the container, but will stop sending traffic to it.
This way the application has more time to become ready and the traffic is not sent to it until it's ready.

A kubernetes service object, like a LoadBalancer or a ClusterIP, has endpoints that are updated with the pods that are ready to receive traffic.
These endpoints are updated by the kubelet removing any pod that has not passed the readiness probe.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: readiness-busybox-example
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - /bin/sh
    - -c
    - "touch /tmp/ready"
    readinessProbe:
      exec:
        command:
        - test
        - -f
        - /tmp/ready
      initialDelaySeconds: 5
      timeoutSeconds: 1
      periodSeconds: 5
      successThreshold: 1
      failureThreshold: 3
```

When we use liveness probe and readiness probe together and the application takes a long time to start, we can reach a scenario where the liveness probe restarts the container
before the readiness probe has passed. In this case, the application will be restarted in a loop and the readiness probe will never pass. To avoid this we can use the *startup probe*.

## Startup probe
Some applications may take a long time to start, like a database that needs to load a large dataset or a web server that needs to load data.
In this case we use a startup probe, that is similar to the liveness probe, but it's only used during the startup of the container.
Another specific of the startup probe is that the liveness and readiness probes are disabled while the startup probe is running, so they do not interfere
with the startup process.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: startup-postgres-example
spec:
  containers:
  - name: postgres
    image: postgres
    env:
    - name: POSTGRES_PASSWORD
      value: "example"
    startupProbe:
      exec:
        command:
        - pg_isready
        - -U
        - postgres
      initialDelaySeconds: 10
      timeoutSeconds: 5
      periodSeconds: 5
      failureThreshold: 10
```

