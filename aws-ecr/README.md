# Openshift and AWS ECR

Using AWS ECR autologin within Openshift.

[Since AWS ECR authentication tokens are valid for 12h](https://aws.amazon.com/blogs/compute/authenticating-amazon-ecr-repositories-for-docker-cli-with-credential-helper/), it's required an autologin system in order to we can pull docker images within our Openshift cluster. 

## Ansible playbook

Openshift cluster deployments are generally based on Ansible, so it will be easy to add a new playbook.

This playbook will create a cron job in master nodes (or on any other machine) which generate or update an specific secret and associate it to the suitable service accounts.

```bash
$ ansible-playbook [--inventory /var/lib/ansible/os-inventory] \
-e "aws_region=<aws_region> aws_access_key_id=<aws_access_key_id> aws_secret_access_key=<aws_secret_access_key>" \
aws-ecr-creds-os.yaml
```
> ``NOTE`` AWS Credentials are required:  aws_region , aws_access_key_id , aws_secret_access_key

## TODO

- [ ] Container : Docker image with ansible and resources.  
- [ ] CronJob : Kubernetes resource to refresh AWS ECR tokens and secrets. 


I hope this helps ;)
