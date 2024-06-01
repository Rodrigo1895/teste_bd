module "shared" {
  source = "./shared"

  projectName                                   = var.projectName
  vpcId                                         = var.vpcId
  vpcCidrBlocks                                 = var.vpcCidrBlocks
  aurora_cluster_pedido_master_password         = module.db_pedido.master_password
  aurora_cluster_pedido_endpoint                = module.db_pedido.endpoint
  aurora_cluster_pedido_master_username         = module.db_pedido.master_username
  aurora_cluster_pedido_database_name           = module.db_pedido.database_name
  aurora_cluster_preparoentrega_master_password = module.db_preparoentrega.master_password
  aurora_cluster_preparoentrega_endpoint        = module.db_preparoentrega.endpoint
  aurora_cluster_preparoentrega_master_username = module.db_preparoentrega.master_username
  aurora_cluster_preparoentrega_database_name   = module.db_preparoentrega.database_name
}

module "db_pedido" {
  source = "./db_pedido"

  projectName       = var.projectName
  password          = var.password
  availabilityZoneA = var.availabilityZoneA
  availabilityZoneB = var.availabilityZoneB
  aurora_sg_id      = module.shared.aurora_sg_id
}

module "db_preparoentrega" {
  source = "./db_preparoentrega"

  projectName       = var.projectName
  password          = var.password
  availabilityZoneA = var.availabilityZoneA
  availabilityZoneB = var.availabilityZoneB
  aurora_sg_id      = module.shared.aurora_sg_id
}

module "db_pagamento" {
  source = "./db_pagamento"
}