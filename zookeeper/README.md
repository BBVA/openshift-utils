# Zookeeper

Here you have some zookeeper deployment examples.

Two kubernetes resources will be used mainly:

* [PetSet](https://kubernetes.io/docs/user-guide/petset/)      (for 1.3<= version < 1.5 of kubernetes)
* [StatefulSet](https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) (since version 1.5 of kubernetes)

A Headless Service will control the network domain for the ZooKeeper processes.
Each pet is available through this service at this hostname from any place inside kubernetes/openshift:

`zk-<i>.zk-svc.<namespace>.svc.cluster.local`

where ***i*** is the pet index and ***namespace*** is the namespace where petset was deployed.

Inside the same namespace you also can use this shortened form:

`zk-<i>.zk-svc`


> NOTE: Dynamic scaling with replicas number changes is not supported yet, :-(
