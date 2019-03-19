output "ec2_public_ip" {
  description = "Instance public IP."
  value = "${aws_instance.nodered_instance.public_ip}"
}

output "nodered_settings_url" {
  description = "Node-Red Settings URL"
  value = "http://${aws_instance.nodered_instance.public_ip}:1880/settings"
}