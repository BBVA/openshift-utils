#!/bin/bash

set -e

SECRET_FILE=/root/secret-aws-ecr.yml

cat > $SECRET_FILE <<EOF
{
    "kind": "Secret",
    "apiVersion": "v1",
    "metadata": {
        "name": "aws-ecr"
    },
    "data": {
         ".dockerconfigjson": "docker_config_json"
    },
    "type": "kubernetes.io/dockerconfigjson"
}
EOF

# AWS ECR Login
$(aws ecr get-login)

# Replace secret value
dockerconfigjson_base64=`echo -n "$(cat /root/.docker/config.json)" | base64 | tr -d '\n'`
sed -i "s/docker_config_json/$dockerconfigjson_base64/g" /root/secret-aws-ecr.yml

PROJECTS=$(oc get projects --no-headers | awk '{print $1}')

SAs=(default deployer builder)

for project in $PROJECTS; do
  echo "Project: $project"
  found=$(oc get secrets -n $project | grep aws-ecr | wc -l)
  if [[ $found -eq 0 ]]; then
    oc create -f /root/secret-aws-ecr.yml -n $project
    echo "Created secret aws-ecr"
    for sa in ${SAs[@]};do
      oc secrets add serviceaccount/$sa secrets/aws-ecr --for=pull -n $project
      echo "Added secret to serviceaccount $sa"
    done
  else
    oc replace -f /root/secret-aws-ecr.yml -n $project
    echo "Updated secret aws-ecr"
  fi
done