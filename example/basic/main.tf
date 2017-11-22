

variable "aws_access_key" { }

variable "aws_secret_key" { }

module "docker-swarm" {
  source="../../terraform/terraform-aws-docker-swarm"
  
  name="projeto_notas"

  manager_count=2
  worker_count=3

  key_name="default"
  key_file="keys/default.pem"
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

resource "null_resource" "nginx" {
  depends_on =["module.docker-swarm"]
  provisioner "local-exec" {
    command="DOCKER_TLS_VERIFY=1 DOCKER_CERT_PATH=keys/demo/$(module.docker-swarm.swarm_managers[0]) DOCKER_HOST=${module.docker-swarm.swarm_managers[0]}:2376 docker service create --name nginx --replicas 1 --publish 80:80 nginx"
  }
}

