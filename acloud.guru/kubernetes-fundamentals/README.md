# Working through ACG Kubernetes Fundamentals Course

## From the "What you'll learn in this course" slide

- Intro
  - History
  - Architecture
  - Terminology
- Deploy
  - Kubernetes in Docker Desktop
  - Play with Kubernetes website
  - Minikube on Windows
  - Minikube on Mac
- Run
  - How to deploy an application to Kubernetes
  - Monitoring applications
  - Scaling applications
  - Using services
  - Kubernetes Storage
  - Updating your applications
- Admin
  - Kubernetes dashboard
  - Managing resources
  - Troubleshooting pods
  - Troubleshooting nodes
  - Using `kubeadm`

## Architecture

this is mostly repeated in the "Terminology section"

There is a nice diagram on [this page](https://kubernetes.io/docs/concepts/overview/components/)

"Master node" - usually a separate physical or virtual machine. manager for entire cluster.
All communication happens through the API

- api
- sched - scheduler
- c-m - controller manager
- etcd -  dist database, only stateful piece of the Master node

in prod, would use multiple highly available etcd

"Node", or worker node, or in the old terminology, "Minions"

- kublet - agent running on each node
- k-proxy - a network proxy
- a container runtime, e.g. docker
- pods

use kubectl to tell Master how many pods you want running at a given time and relay that to the nodes.

"Desired state"

## Terminology

### "Microservices Applications"

as opposed to monolith.
cut up into smaller pieces that can be be scaled independently

### "Container Orchestration"
- optimally runs your workloads
- provides access to storage and networking
- Ensures applications run in the desired state
  - efficiency for developer and administrator
  - high availability
  - load balancer
- uses a declarative model

### "Cluster"
collection of nodes (hosts), storage and network
each cluster has at least one Master

### Master Node
- the control plane of Kubernetes
- Components
  - kube-apiserver
  - etcd - key-value store for all k8s data
  - kube-scheduler
  - kube-controller-manager
  - kube-cloud-controller
- Role is to schedule workloads in form of pods and handle all events.
- phys or virtual
- on-prem or cloud
- eats its own dogfood - the components above are run in pods

### Namespaces

- logical abstraction of cluster to support multiple virtual clusters.
  Can use resource quotas to manage resources per namespace
- default namespaces
  - `default`
  - `kube-system`
  - `kube-public`
- not nestable

### Nodes
- controlled by the master
- components
  - kubelet
  - kube proxy
  - pods themselves - wrappers around containerized workloads
- single host
- on-prem or cloud

### Pods
- unit of work in k8s
- contain 1 or mode containers (typically 1 though)
- containers in pod have same ip and can communicate with each other
- kubectl will only show pods in the `default` namespace by default

## Deployment options

- public cloud
  - roll own
  - managed k8s service AWS Elastic Kubernetes Service, Azure Kubernetes Service, Google Kubernetes Engine
- on prem
  - phys
  - virtual
- lab & testing options
  - vmware fusion, virtual box
  - docker desktop
  - minikube
  - Play with Kubernetes

Limitations:
- minikube only supports single node
- managed - can run workloads but no access to control plane / master nodes

### Installing minikube on mac

Check to see if virtualization is supported:
```shell
$ sysctl -a | grep -E --color 'machdep.cpu.features|VMX'
```

Install Hyperkit with Brew. Hyperkit is the new hotness, I guess. VirtualBox is old and busted
```shell
$ brew install hyperkit
```
Install Minikube with Brew (also installs `kubernetes-cli`)
```shell
$ brew install minikube
```

Install the Docker Client
```shell
$ brew install docker
```

Start Minikube
```shell
$ minikube start
```

Configure the Docker Client
```shell
$ minikube docker-env
```

## Deploying your first application to Kubernetes

- deployments contains pods
- pods contain containers

---

- create a deployment
- scale it up
- expose the deployment (this is called a "service")

```
Running your first container

kubectl create deployment --image nginxdemos/hello web1

kubectl describe deploy web1

kubectl get pods

kubectl get deployment

kubectl scale deployment --replicas 20 web1

kubectl get pods -w

kubectl expose deployment web1 --port=80 --type=LoadBalancer

kubectl get services

minikube service web1

kubectl get deploy web1 -o=yaml

----
kubectl delete deployment web1
```

# Creating deployments from manifest files

- Created in YAML or JSON
- kube can create these for you
- if you use YAML, they are converted to JSON and sent to the k8s API
- imperative
  - run kubectl commands
- declarative
  - DSC : Desired state configuration
  - `kubectl apply -f <manifest file>`
  - "Ensure that this group of 5 web servers and 2 database servers are running at all times with X exposed ports and these resource allocations. If they aren't, restart them"
  - `kubectl apply -k <dir with kustomization file>`


## Monitoring your apps

- get complete list of supported resources with `kubectl api-resources`

```
alias k=kubectl
kubectl api-resources

# Get pods
kubectl get pod

# Get deployments
kubectl get deployment

# Describe pods
kubectl describe pod

# Describe deployment
kubectl describe deploy

# View logs
kubectl logs <podname>
```

## Scaling up your applications

Controller types:

### Deployment

- used for reliability, load balancing and scaling
- creates a replica set
- uses declarative model
- allows you to perform rolling updates with zero downtime

### Replica Sets

- used to main a set of replica pods running at all times
- will add or delete pods as necessary

### DaemonSet

- used to ensure that the same pod is running on all nodes in the cluster and that that pod it started before other pods
- Great for logging or management agents that need to run on every node

### StatefulSet

- Designed for stateful applications, and maintain a sticky identity for each of the pods
- Ideal for applications that need stable network identifiers, persistent storage, ordered deployment and ordered automated rolling updates.

---

- Auto scaling is possible with the autoscale command.

## Using Services

- Are the abstraction that define a set of pods and a policy to access those pods.
- most pods are stateless, and when they die they aren't brought back.
- pods have unique IPs but they aren't exposed outside the cluster without a service
- 4 types
  - ClusterIP (default) - only available intra-cluster
  - NodePort - within node
  - LoadBalancer - publicly available via a cloud provider's load balancer
  - ExternalName - creates a CNAME record
- most prod clusters expose web apps via ingress controllers

## Understanding Kubernetes Storage

- most pods are stateless and any storage in the container / pod is lost when the pod dies
- Kubernetes volumes may solve these problems
  - Container Storage Interface - many vendors supply a CSI compliant driver
- A PersistentVolume (PV) is storage that has been provisioned by an admin or dynamically provisioned using Storage Classes
- A PersistentVolumeClaim (PVC) is a request for storage by the user

## Updating your application

- rolling updates
- users expext websites to be always up
- developers want continuously deploy incremental app updates

```
# Get deployments
kubectl get deploy

# Set the new image to be deployed
kubectl set image deployments/<deployment-name> <container=new-image>

# Check rollout history
kubectl rollout history deploy

# Check rollout status
kubectl rollout status deploy/<deployment-name>

# Undo rollout / rollback
kubectl rollout undo deploy/<deployment-name>
```

## Understanding Namespaces

- a virtual cluster in the physical cluster
- resource names must be unique within the namespace
- by default, there are 3 namespaces
  - default
  - kube-system
  - kube-public

```
# Get namespaces
kubectl get namespace

# Get pods in a namespace
kubectl get pods --namespace=kube-system

# Set your default namespace
kubectl config set-context --current  --namespace=<new-namespace>

# Check to see what your default namespace is
kubectl config view | grep namespace
```

## Managing Resources

Install metrics-server on k8s

```shell
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
```

- control and monitor CPU and memory resources per container
  - limits
  - requests
- scheduled based on resource requests

Can manage from pod yaml file

```yaml
...
spec:
  containers:
    - resources:
        limits:
          cpu:
          memory:
          hugepages-<size>:
          ephemeral-storage:
        requests:
          cpu:
          memory:
          hugepages-<size>:
          ephemeral-storage:
```

### Related commands

```shell
kubectl top node
kubectl top pod
kubectl describe pod <pod-name>
```

## Troubleshooting pods

useful commands:

```shell
kubectl get pods
kubectl describe pods
kubectl logs <pod name> <container name>
kubectl exec -it <pod name> -- /bin/sh
```

- Pod Conditions
  - Pending
  - Running
  - Succeeded
  - Failed
  - Unknown - kube-sched cannot communicate with the node

- Container conditions
  - Waiting
  - Running
  - Terminated

Cannot apply a yaml config to existing pod if resources are being changed.
Instead, delete and recreate it.

"500m" = 500 mili-CPU, or half the cpu

### Live edit of YAML file

```shell
kubectl edit pod <pod name>
```

## Troubleshooting Nodes

### Troubleshooting Master Nodes in a Production Cluster

```shell
$ kubectl get nodes
$ cat /var/log/kube-apiserver.log
$ cat /var/log/kube-scheduler.log
$ cat /var/log/kube-controller-manager.log
```

### Troubleshooting a Standard Node

```shell
cat /var/log/kubelet.log
cat /var/kube-proxy.log
```

## Understanding `kubeadm`

IMPORTANT: Never have an even number of master or etcd nodes.
Typically you'll have 3 or 5

- Best practice tool to fast-path the deployment of a multi-node cluster.
- Sub-commands include
  - `init` - run on the master node to initialize a cluster
  - `join` - run on the node to join the node to the cluster, using the join token from `init`

## Links

- [Kubernetes Docs](https://kubernetes.io/docs)
- [Kubernetes Slack](https://slack.k8s.io)
