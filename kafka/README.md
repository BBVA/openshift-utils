# Kafka cluster

Kafka cluster deployment

## Topologies

We've got three ways to deploy a kafka cluster :

### Single All-in-one

Both zookeeper and kafka processes running in the same pod.

By default when someone launch a pod based on `bbvalabs/kafka` docker image we'll have a container with these processes running

### External zookeeper

Deploy kafka brokers with external zookeeper connection.

This env variables are required :

* KAFKA_ZK_LOCAL=false
* SERVER_zookeeper_connect=\<your-zookeeper-nodes\>

### Clustered All-in-one

A zookeeper cluster with a broker for each one.







