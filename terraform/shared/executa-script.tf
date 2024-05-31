resource "null_resource" "aplica-script-database" {
  depends_on = [aws_rds_cluster.aurora-cluster-pedido, aws_rds_cluster_instance.aurora-instance-pedido,
    aws_rds_cluster.aurora-cluster-preparoentrega, aws_rds_cluster_instance.aurora-instance-preparoentrega,
  aws_instance.bastion]

  provisioner "local-exec" {
    command = <<EOT
      chmod 400 ../ssh_bastion/easy-food-bastion.pem &&
      ssh -o StrictHostKeyChecking=no -i ../ssh_bastion/easy-food-bastion.pem ec2-user@${aws_instance.bastion.public_ip} "sudo dnf -y install postgresql15" &&
      scp -i ../ssh_bastion/easy-food-bastion.pem ../../scripts/* ec2-user@${aws_instance.bastion.public_ip}:/tmp &&
      ssh -o StrictHostKeyChecking=no -i ../ssh_bastion/easy-food-bastion.pem ec2-user@${aws_instance.bastion.public_ip} "PGPASSWORD=${aws_rds_cluster.aurora-cluster-pedido.master_password} psql -h ${aws_rds_cluster.aurora-cluster-pedido.endpoint} -U ${aws_rds_cluster.aurora-cluster-pedido.master_username} -d ${aws_rds_cluster.aurora-cluster-pedido.database_name} -f /tmp/init_script_pedido.sql" &&
      ssh -o StrictHostKeyChecking=no -i ../ssh_bastion/easy-food-bastion.pem ec2-user@${aws_instance.bastion.public_ip} "PGPASSWORD=${aws_rds_cluster.aurora-cluster-preparoentrega.master_password} psql -h ${aws_rds_cluster.aurora-cluster-preparoentrega.endpoint} -U ${aws_rds_cluster.aurora-cluster-preparoentrega.master_username} -d ${aws_rds_cluster.aurora-cluster-preparoentrega.database_name} -f /tmp/init_script_preparoentrega.sql"
    EOT
  }
}