# Kafka cluster

Kafka cluster deployment.

The resources found here are templates for Openshift.

Two kubernetes resources will be used mainly:

* [PetSet](https://kubernetes.io/docs/user-guide/petset/) (for 1.3<= kubernetes version < 1.5)
* [StatefulSet](https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) (since version 1.5 of kubernetes)

A Headless Service will control the network domain for the ZooKeeper processes.
Each pet is available through this service at this hostname from any place inside kubernetes/openshift:

`zk-<i>.zk-svc.<namespace>.svc.cluster.local`

where ***i*** is the pet index and ***namespace*** is the namespace where petset was deployed.

Inside the same namespace you also can use this shortened form: `zk-<i>.zk`

## Topologies

We've got two ways to deploy a kafka cluster (and Ephemeral and Persistent modes according the storage type that you prefer):

Users can choose how to connect to a zookeeper cluster by configuring these parameters:

* **KAFKA_ZK_LOCAL**: set to 'true' value if an internal zookeeper process should be run. Change to 'false' if you have a reachable zookeeper cluster to connect to.
* **SERVER_zookeeper_connect**=\<your-zookeeper-nodes\>. This property is required if `KAFKA_ZK_LOCAL=false` in other case the connection string will be auto-generated.

The resources `petset.yaml` and `statefulset.yaml` can be launched with internal (`KAFKA_ZK_LOCAL=true`) or external (`KAFKA_ZK_LOCAL=false` and `SERVER_zookeeper_connect`) zookeeper.
Both cases haven't persistent storage and would be appropriated for testing purposes.

For production environments we recommend you to use resources with suffixes `persistent` (`KAFKA_ZK_LOCAL=false` and `SERVER_zookeeper_connect`) or `zk-persistent` (`KAFKA_ZK_LOCAL=true`).
Theses both resources use persistent storage with different capacities for each one.

### Examples
#### Ephemeral cluster with Zookeeper sidecar

```bash
$ oc create -f <petset|stafulset>.yaml
$ oc new-app kafka -p REPLICAS=1
```

> NOTE: params between '[]' characters are optional.

The number of nodes must be a valid quorum for zookeeper (1, 3, 5, ...).
For example, if you want to have a quorum of 3 zookeeper nodes, then we'll have got 3 kafka brokers too.

#### Persistent storage with external Zookeeper

First of all, [deploy a zookeeper cluster](https://github.com/engapa/zookeeper-k8s-openshift).

```bash
$ oc create -f <petset|stafulset>[-zk]-persistent.yaml
$ oc new-app kafka -p SERVER_zookeeper_connect=<zookeeper-nodes>
```

## Local testing

We recommend to use "minishift" in order to get quickly a ready Openshift deployment.

Check out the Openshift version by typing:

```bash
$ minishift get-openshift-versions
$ minishift config get openshift-version
```

If no version is showed in last command this means that the latest stable version is being used.

Setup the right template according to use Petsets or StatefulSets:

```bash
$ minishift config set openshift-version <version>
$ minishift start
$ oc create -f <template>.yaml
$ oc new-app kafka [-p parameter=value]
$ minishift console
```

## Clean up

To remove all resources related to one kafka cluster deployment launch this command:

```sh
$ oc delete all,<petset|statefulset>[,pvc] -l kafka-name=<name> [-n <namespace>|--all-namespaces]
```
where '\<name\>' is the value of param NAME. Note that pvc resources are marked as optional in the command,
it's up to you preserve or not the persistent volumes (by default when a pvc is deleted the persistent volume will be deleted as well).
Type the namespace option if you are in a different namespace from resources are, and indicate `--all-namespaces` option if all namespaces should be considered.

It's possible to delete all resources created by using the template:

```sh
$ oc delete all,<petset|statefulset>[,pvc] -l template=kafka[-zk][-persistent] [-n <namespace>] [--all-namespaces]
```

Also someone can remove all resources of type kafka belong to all clusters and templates:

```sh
$ oc delete all,<petset|statefulset>[,pvc] -l component=kafka [-n <namespace>] [--all-namespaces]
```

And finally, if you even want to remove the templates:

```sh
$ oc delete template kafka[-zk][-persistent] [-n <namespace>] [--all-namespaces]
```
