# Zookeeper

Here you have some zookeeper deployment examples.

Two kubernetes resources will be used mainly:

* [PetSet](https://kubernetes.io/docs/user-guide/petset/)      (for 1.3<= kubernetes version < 1.5)
* [StatefulSet](https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) (since version 1.5 of kubernetes)

A Headless Service will control the network domain for the ZooKeeper processes.
Each pet is available through this service at this hostname from any place inside kubernetes/openshift:

`zk-<i>.zk-svc.<namespace>.svc.cluster.local`

where ***i*** is the pet index and ***namespace*** is the namespace where petset was deployed.

Inside the same namespace you also can use this shortened form: `zk-<i>.zk`

## Local environment

We recommend to use "minishift" in order to get quickly a ready Openshift deployment.

Check out the Openshift version by typing:

```bash
$ minishift get-openshift-versions
$ minishift config get openshift-version
```

If no version is showed in last command this means that the latest stable version is being used.

Setup the right template according to use Petsets or StatefulSets:

```bash
$ minishift config set openshift-version <openshift-version>
$ minishift start
$ oc create -f <petset|statefulset>[-persistent].yaml
$ oc new-app zk[-persistent] [-p parameter=value ...]
$ minishift console
```

> NOTE: values between "[]" characters are optional.

## Production environment

We recommend you to use resources with suffix **persistent** because of persistent storage.
This means that although pods are destroyed all data are safe under persistent volumes, and when pod are recreated the volumes are attached again.

These resources have an "antiaffinity" pod scheduler policy so pods will be allocated in separate nodes.
It's required the same number of nodes that the value of parameter `ZOO_REPLICAS`.

```bash
$ oc login https://oorigin.myprod.com
$ oc create -f statefulset-persistent.yaml
$ oc new-app zk-persistent -p NAME=myzk
--> Deploying template "test/zk-persistent" to project test

     Zookeeper (Persistent)
     ---------
     Create a replicated Zookeeper server (Statefulset) with persistent storage


     * With parameters:
        * NAME=myzk
        * SOURCE_IMAGE=bbvalabs/zookeeper
        * ZOO_VERSION=3.4.10
        * ZOO_REPLICAS=3
        * VOLUME_DATA_CAPACITY=1Gi
        * VOLUME_DATALOG_CAPACITY=1Gi
        * ZOO_TICK_TIME=2000
        * ZOO_INIT_LIMIT=5
        * ZOO_SYNC_LIMIT=2
        * ZOO_CLIENT_PORT=2181
        * ZOO_SERVER_PORT=2888
        * ZOO_ELECTION_PORT=3888
        * ZOO_MAX_CLIENT_CNXNS=60
        * ZOO_SNAP_RETAIN_COUNT=3
        * ZOO_PURGE_INTERVAL=1
        * ZOO_HEAP_SIZE=-Xmx960M -Xms960M
        * RESOURCE_MEMORY_REQ=1Gi
        * RESOURCE_MEMORY_LIMIT=1Gi
        * RESOURCE_CPU_REQ=1
        * RESOURCE_CPU_LIMIT=2

--> Creating resources ...
    service "myzk" created
    statefulset "myzk" created
--> Success
    Run 'oc status' to view your app.

$ oc get all,pvc,statefulset -l app=myzk
NAME       CLUSTER-IP   EXTERNAL-IP   PORT(S)                      AGE
svc/myzk   None         <none>        2181/TCP,2888/TCP,3888/TCP   11m

NAME                DESIRED   CURRENT   AGE
statefulsets/myzk   3         3         11m

NAME        READY     STATUS    RESTARTS   AGE
po/myzk-0   1/1       Running   0          2m
po/myzk-1   1/1       Running   0          1m
po/myzk-2   1/1       Running   0          46s

NAME                    STATUS    VOLUME                                     CAPACITY   ACCESSMODES   AGE
pvc/datadir-myzk-0      Bound     pvc-a654d055-6dfa-11e7-abe1-42010a840002   1Gi        RWO           11m
pvc/datadir-myzk-1      Bound     pvc-a6601148-6dfa-11e7-abe1-42010a840002   1Gi        RWO           11m
pvc/datadir-myzk-2      Bound     pvc-a667fa41-6dfa-11e7-abe1-42010a840002   1Gi        RWO           11m
pvc/datalogdir-myzk-0   Bound     pvc-a657ff77-6dfa-11e7-abe1-42010a840002   1Gi        RWO           11m
pvc/datalogdir-myzk-1   Bound     pvc-a664407a-6dfa-11e7-abe1-42010a840002   1Gi        RWO           11m
pvc/datalogdir-myzk-2   Bound     pvc-a66b85f7-6dfa-11e7-abe1-42010a840002   1Gi        RWO           11m

NAME                DESIRED   CURRENT   AGE
statefulsets/myzk   3         3         11m
```

## Clean up

To remove all resources related to one zookeeper cluster deployment launch this command:

```sh
$ oc delete all,<petset|statefulset>[,pvc] -l zk-name=<name> [-n <namespace>|--all-namespaces]
```
where '<name>' is the value of param NAME. Note that pvc resources are marked as optional in the command,
it's up to you preserver or not the persistent volumes (by default when a pvc is deleted the persistent volume will be deleted as well).
Type the namespace option if you are in a different namespace that resources are, and indicate --all-namespaces option if all namespaces should be considered.

It's possible delete all resources created by using the template:
with cluster created by template name:

```sh
$ oc delete all,<petset|statefulset>[,pvc] -l template=zk[-persistent] [-n <namespace>] [--all-namespaces]
```

Also someone can remove all resources of type zk, belong to all clusters and templates:

```sh
$ oc delete all,<petset|statefulset>[,pvc] -l component=zk [-n <namespace>] [--all-namespaces]
```

And finally if you even want to remove the template:

```sh
$ oc delete template zk[-persistent] [-n <namespace>] [--all-namespaces]
```