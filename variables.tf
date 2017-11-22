

variable "region" {
  description="The region where to create your instances."
  default="us-east-1"
}

variable "instance_type" {
  description="The machine type to create the instances."
  default="t2.micro"
}

variable "name" {
  description="The name of your docker swarm, used for identification and to separate different swarm. Also will be the name of the fold where to store the TLS keys and certificates."
  default="MyService"
}

variable "manager_count" {
  description="Number of managers to create."
  default=1
}

variable "worker_count" {
  description="Number of workers to create."
  default=3
}

variable "volume_size" {
  description="Size of local volume in GB for each node."
  default="25"
}

variable "bastion" {
  description="Bastion to use to access instances, if any."
  default=""
}
variable "vpc" {
  description="VPC to add instances to."
  default=""
}

variable "subnet" {
  description="Subnet to add instances to."
  default=""
}

variable "security_group" {
  description="Security group to add instances to."
  default=""
}

variable "key_name" {
  description="Key name to use to access and provision instances."
  default=""
}

variable "key_file" {
  description="Key file to use to access and provision instances."
  default="keys"
}

variable "label" {
  description="Label to add to each docker node."
  default=""
}

variable "join_existing_swarm" {
  description="Join an existing swarm cluster instead of initing a new one. Not tested."
  default=false
}

variable "existing_swarm_manager" {
  description="If setup to join an existing swarm cluster instead of initing a new one, this points to the manager node of the existing swarm cluster. Not tested."
  default=""
}

