# Tensorflow examples

Tensorflow templates examples for Openshift.

## Create a template

If you want to create a template in your Openshift project then launch the command below:

```bash
$ oc create -f tf-cpu-template.yaml -n <project>
```

After that, the template is ready for you (under the project <project>)

```bash
$ oc new-app tf-cpu [-p parameter=value] -n <project>
```

> ``NOTE`` By default, if no changes were applied on master configuration, there used to be a shared project named 'openshift',
 if the template is created within this project then all users could use it

## Create resources directly

You'd rather create resources directly than use a template, go ahead :

```bash
$ oc process -f tf-cpu-template.yaml [-v parameter=value] | oc create -f -
```

## Routes

To reach the service endpoints it's required to create a pair of routes:

```bash
$ oc expose svc/<NAME> --name tf-jupyter --port ipython
$ oc expose svc/<NAME> --name tf-board --port tensorboard
```








