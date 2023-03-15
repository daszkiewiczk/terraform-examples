output "instance_id" {
  value = aws_instance.sonarqube.id
}
#note: it outputs the previous public IP for some reason
output "instance_public_ip" {
  value = aws_instance.sonarqube.public_ip
}