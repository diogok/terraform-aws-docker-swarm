
output "swarm_managers" {
  description="Public IPs of the swarm managers"
  value=["${aws_instance.swarm_manager.*.public_ip}"]
}

output "swarm_workers" {
  description="Public IPs of the swarm workers"
  value=["${aws_instance.swarm_worker.*.public_ip}"]
}

output "docker-env" {
  description="Environment variables setup to control the swarm locally. Just call as $(terraform output docker-env)."
  value =<<EOF
export DOCKER_HOST=${aws_instance.swarm_manager.0.public_ip}:2376
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=keys/${var.name}/${aws_instance.swarm_manager.0.public_ip}
EOF
}

