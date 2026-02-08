from diagrams import Diagram

from diagrams.digitalocean.compute import K8SCluster, K8SNodePool
from diagrams.digitalocean.database import DbaasPrimary
from diagrams.digitalocean.network import Domain, Vpc, LoadBalancer

with Diagram("Infrastructure System Context", show=False, filename="context_diagram"):

    vpc = Vpc("vpc")
    domain = Domain("domain: recfab.net")

    lb = LoadBalancer("Load Balancer")
    kube = K8SCluster("Kubernetes Cluster")
    db = DbaasPrimary("PostgreSQL Database")

    vpc >> [lb, kube, db]

    pool = K8SNodePool("Node pool")

    domain >> lb
    lb >> kube
    kube >> pool
    kube >> db
