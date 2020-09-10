output "WS1-IP" {
  value       = aws_instance.ws-vm1.public_ip
  description = "The IP for Web server 1"
}

output "WS2-IP" {
  value       = aws_instance.ws-vm2.public_ip
  description = "The IP for Web server 2"
}

output "SQL-IP" {
  value       = aws_instance.sql-vm.public_ip
  description = "The IP of SQL server"
}

output "Client-IP" {
  value       = aws_instance.client-vm.public_ip
  description = "The IP for client VM"
}


