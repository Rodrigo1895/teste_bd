resource "null_resource" "aplica-script-database" {
  depends_on = [aws_instance.bastion]

  provisioner "local-exec" {
    command = <<EOT
      chmod 400 ./ssh_bastion/easy-food-bastion.pem &&
      ssh -o StrictHostKeyChecking=no -i ./ssh_bastion/easy-food-bastion.pem ec2-user@${aws_instance.bastion.public_ip} "sudo dnf -y install postgresql15" &&
      scp -i ./ssh_bastion/easy-food-bastion.pem ../scripts/* ec2-user@${aws_instance.bastion.public_ip}:/tmp &&
      ssh -o StrictHostKeyChecking=no -i ./ssh_bastion/easy-food-bastion.pem ec2-user@${aws_instance.bastion.public_ip} "PGPASSWORD=${var.aurora_cluster_pedido_master_password} psql -h ${var.aurora_cluster_pedido_endpoint} -U ${var.aurora_cluster_pedido_master_username} -d ${var.aurora_cluster_pedido_database_name} -f /tmp/init_script_pedido.sql" &&
      ssh -o StrictHostKeyChecking=no -i ./ssh_bastion/easy-food-bastion.pem ec2-user@${aws_instance.bastion.public_ip} "PGPASSWORD=${var.aurora_cluster_preparoentrega_master_password} psql -h ${var.aurora_cluster_preparoentrega_endpoint} -U ${var.aurora_cluster_preparoentrega_master_username} -d ${var.aurora_cluster_preparoentrega_database_name} -f /tmp/init_script_preparoentrega.sql"
    EOT
  }
}