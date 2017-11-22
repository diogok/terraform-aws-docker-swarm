
provider "aws" {
  region="${var.region}"
}

data "aws_vpc" "default" {
  default=true
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_subnet" "default" {
  count = "${length(data.aws_subnet_ids.default.ids)}"
  id = "${data.aws_subnet_ids.default.ids[count.index]}"
}

locals {

  amis = {
    "ap-northeast-1"="ami-b6b568d0"
    "ap-northeast-2"="ami-b7479dd9"
    "ap-south-1"="ami-02aded6d"
    "ap-southeast-1"="ami-d76019b4"
    "ap-southeast-2"="ami-8359bae1"
    "ca-central-1"="ami-3709b053"
    "eu-central-1"="ami-8bb70be4"
    "eu-west-1"="ami-ce76a7b7"
    "eu-west-2"="ami-a6f9ebc2"
    "sa-east-1"="ami-f5c7b899"
    "us-east-1"="ami-71b7750b"
    "us-east-2"="ami-dab895bf"
    "us-west-1"="ami-58eedd38"
    "us-west-2"="ami-c032f6b8"
  }

  ami = "${lookup(local.amis,var.region)}"

  subnet = "${var.subnet==""?data.aws_subnet.default.0.id:var.subnet}"
}

data "aws_ami" "debian" {
  filter {
    name   = "image-id"
    values = ["${local.ami}"]
  }
}
