# Openshift Utils

Utilities for Openshift

## Deploy Openshift on Openstack

In order to deploy Openshift in our Openstack (EuroCloud/InnoCloud) we've extended the official [repository](https://github.com/redhat-openstack/openshift-on-openstack) in this one:

https://github.com/BBVA/openshift-on-openstack

All information may be found at official [user guide](https://docs.google.com/document/d/1PQLGCDhBnRWDwV-MG0-KKEqMyhnRbFRba21JnzadCYE/edit#heading=h.8iro3ytzmhv2) .

## Openshift templates

Template list:

- [Kafka](kafka)
- [Zookeeper](zookeeper)
- [Tensorflow](tensorflow)

## Openshift AWS ECR

Integrate AWS ECR as external docker registry

- [AWS ECR](aws-ecr)

## Local tests

We recommend using ["minishift"](https://www.openshift.org/vm/) , this is the easiest way to have a local Openshift.

The resources with suffix ***local*** have been created in order to be launched on previous production environments (in your localhost, for instance).


