#Export the public IPs of servers to a file
resource "local_file" "tf_ansible_vars" {
  content  = <<-DOC
    ws_vm1_IP=${aws_instance.ws-vm1.public_ip}
    ws_vm2_IP=${aws_instance.ws-vm2.public_ip}
    sql_vm_IP=${aws_instance.sql-vm.public_ip}
    DOC
  filename = "./tf_ansible_vars_file.yaml"
}
