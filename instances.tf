#Get Linux AMI ID with SSM Parameter
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.ucpe
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create keypair for logging into VM
resource "aws_key_pair" "ucpe-keypair" {
  provider   = aws.ucpe
  key_name   = "unlock-ucpe"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Instantiate and configure EC2 client VM
resource "aws_instance" "client-vm" {
  provider                    = aws.ucpe
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ucpe-keypair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sc-sg.id]
  private_ip                  = "10.0.1.4"
  subnet_id                   = aws_subnet.subnet_1.id
  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/deploy_base.yaml
EOF
  }

  tags = {
    Name = "client_vm"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

#Instantiate and configure EC2 WS1
resource "aws_instance" "ws-vm1" {
  provider                    = aws.ucpe
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ucpe-keypair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ws-sg.id]
  private_ip                  = "10.0.2.4"
  subnet_id                   = aws_subnet.subnet_2.id
  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/deploy_webserver.yaml
EOF
  }

  tags = {
    Name = "ws_vm1"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

}

#Instantiate and configure EC2 WS2
resource "aws_instance" "ws-vm2" {
  provider                    = aws.ucpe
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ucpe-keypair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ws-sg.id]
  private_ip                  = "10.0.3.4"
  subnet_id                   = aws_subnet.subnet_3.id
  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/deploy_webserver.yaml
EOF
  }

  tags = {
    Name = "ws_vm2"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

}


#Instantiate and configure EC2 SQL
resource "aws_instance" "sql-vm" {
  provider                    = aws.ucpe
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ucpe-keypair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sql-sg.id]
  private_ip                  = "10.0.4.4"
  subnet_id                   = aws_subnet.subnet_4.id
  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/deploy_sql.yaml
EOF
  }

  tags = {
    Name = "sql_vm"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

