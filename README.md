# Terraform AWS Docker Swarm Module

This module creates a docker swarm cluster with TLS enabled on AWS.

It does not create network security groups, key pair or load balancer. Docker access is secured using TLS certificates.

## Dependencies

Minimal versions:

- Terraform 0.10.6
- Docker engine 17.06.2-ce
- An AWS account

## Usage

Example usage of the module.

```
# aws access variables

module "docker-swarm" {
  source="github.com/diogok/terraform-aws-docker-swarm" 

  name="demo"

  manager_count=1
  worker_count=3

  key_name="yourkey"
  key_file="path/to/yourkey.pem"
}

output "managers" {
  value="${module.docker-swarm.swarm_managers}"
}

output "workers" {
  value="${module.docker-swarm.swarm_workers}"
}

output "docker-env" {
   value="${module.docker-swarm.docker-env}"
}
```

You can control the swarm manager with this command:

```
$(terraform output docker-env)
```

This will export properlty DOCKER\_HOST , DOCKER\_TLS\_VERIFY and DOCKER\_CERT\_PATH to securily connect docker to the manager.

It will generate the TLS certs at your local "keys" folder, on folder for each name and one folder for each IP of a manager. Only manager get docker daemon exposed.

## License

MIT

