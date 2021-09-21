data "aws_ami" "amazon_linux" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_efs_file_system" "a" {
  tags = {
    Name = var.basename
  }
}
output efs {
  value = aws_efs_file_system.a
}

resource "aws_efs_mount_target" "a" {
  file_system_id = aws_efs_file_system.a.id
  subnet_id      = aws_instance.a.subnet_id
}

locals {
  user_data = <<EOS
#!/bin/bash
set -x
echo Starting
dns_name="${aws_efs_file_system.a.dns_name}"
dns_name=fs-9fb36f99.efs.us-west-2.amazonaws.com
echo $dns_name
yum install -y amazon-efs-utils
python3 --version
pip3 --version
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
python3 /tmp/get-pip.py
/usr/local/bin/pip3 install botocore
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $dns_name
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $dns_name:/ /mnt/efs
date > /mnt/efs/$(date +%s)
sync;sync
EOS
}

output user_data {
  value = local.user_data
}

resource "aws_instance" "a" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name = "pfq"
  tags = {
    Name = var.basename
  }
  user_data = local.user_data
}

output a {
  value = aws_instance.a.public_ip
}
