# Kafka cluster

Kafka cluster deployment

## Topologies

We've got three ways to deploy a kafka cluster :

### Single All-in-one (zookeeper sidecar)

Both zookeeper and kafka processes running in the same pod.

By default when someone launches a pod based on `bbvalabs/kafka` docker image we'll have a container with these processes running together.

This topology is ver useful for developers or testing purposes.

### External zookeeper

Deploy kafka brokers with external zookeeper connection.

This env variables are required :

* KAFKA_ZK_LOCAL=false
* SERVER_zookeeper_connect=\<your-zookeeper-nodes\>

This topology is the most convenient in production environments.

### Clustered All-in-one (zookeeper cluster sidecar)

A zookeeper cluster with a kafka broker inside each node.
The number of nodes must be a valid quorum for zookeeper (1, 3, 5, ...).

For example if you want to have a quorum of 3 zookeeper nodes , then we have 3 brokers too.











