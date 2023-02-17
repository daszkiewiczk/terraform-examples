output "instance_id" {
  value = aws_instance.web.id
}
#note: it outputs the previous public IP for some reason
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}