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


> NOTE: Dynamic scaling up or down is not supported yet, :-(

## Notes

PetSets are available from kubernetes ***1.3***, and from version ***1.5*** they are renamed as StatefulSets.

### Local testing

We recommend to use "minishift" in order to get quickly a ready Openshift deployment.

Check out the Openshift version by typing:

```bash
$ minishift get-openshift-versions
$ minishift config get openshift-version
```

If no version is showed in last command this means that the latest stable version is being used.

Setup the right version in order to use Petsets or StatefulSets:

```bash
$ minishift config set openshift-version <version>
$ minishift start
$ oc create -f <template>-local.yaml
$ oc new-app <template-name>-local.yaml [-p parameter=value]
$ minishift console
```