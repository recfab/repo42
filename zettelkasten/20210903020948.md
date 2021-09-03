---
id: 20210903020948
---
# Istio

- from [^appreq]
  > `NET_ADMIN` and `NET_RAW` capabilities: If pod security policies are enforced in your cluster and unless you use the Istio CNI Plugin, your pods must have the `NET_ADMIN` and `NET_RAW` capabilities allowed. The initialization containers of the Envoy proxies require these capabilities.

- "Virtual Services"
  - could help us with A/B testing and/or deployments
  - can point to multiple "real" service
  - can help process of splitting up a monolith e.g. by specifying certain sub-paths go to certain services
- does not have to use kubernetes
- can set timeout policy
- can set retry policy
  - defaults to twice
  - can adjust in Virtual Service for each real service
- can set circuit breaker
- Failure Injection enables testing the configurations
  - delays
  - aborts

## Questions

- [ ] Question: Do you still need an Ingress with Istio?

[^appreq]: https://istio.io/latest/docs/ops/deployment/requirements/

[traffic]: https://istio.io/latest/docs/concepts/traffic-management
[protocol]: https://istio.io/latest/docs/ops/configuration/traffic-management/protocol-selection/
