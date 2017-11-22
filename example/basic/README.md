
# Terraform docker swarm on AWS

This is an example on how to use the terraform-swarm-docker-swarm module.

Take a look at the main.tf.

## Usage

Copy "terraform.tfvars.dist" to "terraform.tfvars" and fill in the variables with your keys.

Also have a generated key\_pair pem somewhere accessible.

Once "terraform apply" executes it will create the configured cluster and store the generated TLS keys needed to control the swarm at a local "keys" folder. Make sure to keep this folder around but out of version control.

You can control the swarm manager by issuing "${terraform output docker-env}" and them all docker commands will be using the first manager.

## LICENSE

MIT

