
resource "aws_instance" "swarm_manager" {
  count = "${var.manager_count}"

  ami           = "${data.aws_ami.debian.id}"
  instance_type = "${var.instance_type}"

  tags {
    Name  = "${var.name} docker swarm manager ${count.index}"
  }

  #vpc_security_group_ids = ["${local.security_group}"]
  subnet_id = "${local.subnet}"

  root_block_device = { 
    volume_size="${var.volume_size}"
  }

  key_name = "${var.key_name}"
  associate_public_ip_address=true
}

resource "null_resource" "swarm_manager" {
  depends_on=["aws_instance.swarm_manager"]

  count = "${aws_instance.swarm_manager.count}"

  triggers = {
    manager_ids = "${join(",",aws_instance.swarm_manager.*.id)}"
  }

  connection  {
    type = "ssh"
    user = "admin"
    private_key = "${file(var.key_file)}"
    host = "${element(aws_instance.swarm_manager.*.public_ip,count.index)}"

    bastion_host="${var.bastion}"
  }

  provisioner "remote-exec" {
    inline =[
        "sleep 10"
       ,"echo ${count.index} > /tmp/index"
       ,"echo ${var.label} > /tmp/label"
       ,"echo manager > /tmp/role"
       ,"echo '${var.join_existing_swarm?var.existing_swarm_manager:aws_instance.swarm_manager.0.private_ip}' > /tmp/swarm_manager"
       ,"echo '$(cat /tmp/swarm_manager) swarm_manager' | sudo tee -a /etc/hosts"
    ]
  }

  provisioner "local-exec" {
    command=<<EOF
docker run \
  -v "$PWD/keys/${var.name}/${element(aws_instance.swarm_manager.*.public_ip,count.index)}:/opt/keys" \
  -v "${path.module}/scripts:/opt/scripts" \
  centurylink/openssl \
  sh /opt/scripts/create-docker-tls.sh /opt/keys localhost ${element(aws_instance.swarm_manager.*.public_ip,count.index)} ${element(aws_instance.swarm_manager.*.private_ip,count.index)}
EOF
  }

  provisioner "remote-exec" {
    inline=["sudo mkdir -p /opt/keys/manager","sleep 15","sudo chown admin.admin /opt/keys -Rf"]
  }

  provisioner "file" {
    source="keys/${var.name}/${element(aws_instance.swarm_manager.*.public_ip,count.index)}/"
    destination="/opt/keys"
  }

  provisioner "file" {
    source="keys/${var.name}/${var.join_existing_swarm?var.existing_swarm_manager:aws_instance.swarm_manager.0.public_ip}/"
    destination="/opt/keys/manager"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/limits.sh"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/install-docker.sh"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/docker-init-or-join.sh"
  }
}
