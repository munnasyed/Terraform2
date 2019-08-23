provider "aws"{
access_key="AKIAZTIMJ7JHPVODYVZA"
secret_key="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"
region="eu-west-1"
//access_key="${var.access_key}"
//secret_key="${var.secret_key}"
//region="${var.region}"
}

resource "aws_instance" "munnasampletf1"{
ami="ami-06358f49b5839867c"
instance_type="t2.micro"
key_name="${aws_key_pair.munnakeypair.id}"

tags={
Name="munnacloudinstancename"
}
vpc_security_group_ids =["${aws_security_group.munnasecuritygroup.id}"]
provisioner "local-exec"{
when="create"
command="echo ${aws_instance.munnasampletf1.public_ip}>sample.txt"
}
provisioner "chef"{
connection {
host="${self.public_ip}"
type="ssh"
user="ubuntu"
private_key="${file("C:\\Munna\\mykey.pem")}"
}
client_options =["chef_license 'accept'"]
run_list=["munna_tf_chef::default"]
recreate_client=true
node_name="tfmunna.acc.come"
server_url="https://manage.chef.io/organizations/accs"
user_name="munnasyed"
user_key="${file("C:\\chef-starter\\chef-repo\\.chef\\munnasyed.pem")}"
ssl_verify_mode=":verify_none"
}

}


output "munnaipaddress"{
value="${aws_instance.munnasampletf1.public_ip}"
}
resource "aws_key_pair" "munnakeypair"{
key_name="munnakey"
public_key="${file("C:\\Munna\\mykey.pub")}"
}

resource "aws_eip" "munnaelasticip"{
tags={
Name="munnaelasticip"
}
instance="${aws_instance.munnasampletf1.id}"

}


resource "aws_s3_bucket" "munnabucket"{
bucket="munnabucket"
acl="private"
force_destroy="true"
}

resource "aws_security_group" "munnasecuritygroup"{
name="munnasecgroup"
description="To allow traffic"
ingress{
from_port="0"
to_port="0"
protocol="-1"
cidr_blocks=["0.0.0.0/0"]
}
egress{
from_port="0"
to_port="0"
protocol="-1"
cidr_blocks=["0.0.0.0/0"]
}
}

terraform{
backend "s3"{
bucket="munnabucket"
key="terraform.tfstate"
region="eu-west-1"
}
}
