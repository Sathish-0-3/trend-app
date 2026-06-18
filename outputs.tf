output "vpc_id" {

  value = aws_vpc.trend_vpc.id

}

output "public_subnet" {

  value = aws_subnet.public_subnet.id

}

output "security_group" {

  value = aws_security_group.jenkins_sg.id

}

output "instance_id" {

  value = aws_instance.jenkins.id

}

output "public_ip" {

  value = aws_instance.jenkins.public_ip

}

output "public_dns" {

  value = aws_instance.jenkins.public_dns

}

output "jenkins_url" {

  value = "http://${aws_instance.jenkins.public_ip}:8080"

}
