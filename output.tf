output "openvpn-ip" {
  value = [aws_instance.openvpn-instance.*.public_ip]
}
