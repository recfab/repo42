from diagrams import Diagram, Edge, Cluster

from diagrams.k8s.others import CRD

from diagrams.onprem.vcs import Gitlab
from diagrams.onprem.gitops import ArgoCD
from diagrams.onprem.monitoring import Prometheus
from diagrams.onprem.network import Istio


def defined_by(crd, chart):
    crd >> Edge(label="defined by") >> chart


def depends_on(chart, crd, required=True):
    style = "solid" if required else "dashed"
    chart >> Edge(label="depends on", style=style) >> crd


with Diagram(
    "Helm Chart Runtime Dependencies", show=False, filename="helm_dependency_diagram"
):

    Gitlab("gitlab-agent")

    argocd = ArgoCD("argo-cd")

    Istio("istio")

    with Cluster("kube-prometheus-stack"):
        prometheus = Prometheus("prometheus")
        serviceMonitor = CRD("ServiceMonitor")

        defined_by(serviceMonitor, prometheus)
    depends_on(argocd, serviceMonitor, required=False)
