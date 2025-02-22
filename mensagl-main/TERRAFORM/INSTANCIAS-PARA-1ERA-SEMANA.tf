# ============================
# Instancias EC2
# ============================

# Proxy Inverso en Zona 1
resource "aws_instance" "proxy_zona1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public1.id
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_proxy.id]
  associate_public_ip_address = true
  private_ip             = "10.0.1.10"

  # User Data para cargar el script.sh
  user_data = templatefile("${path.module}/SCRIPTS-AUTOMATIZACION/PROXY/proxy-zona1_sin_cluster.sh", {})

  tags = {
    Name = "proxy-zona1"
  }

  depends_on = [
    aws_vpc.main,
    aws_subnet.public1,
    aws_security_group.sg_proxy,
    aws_key_pair.ssh_key
  ]
}

# Proxy Inverso en Zona 2
resource "aws_instance" "proxy_zona2" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public2.id
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_proxy.id]
  associate_public_ip_address = true
  private_ip             = "10.0.2.10"

  # User Data para cargar el script.sh
  user_data = templatefile("${path.module}/SCRIPTS-AUTOMATIZACION/PROXY/proxy-zona2_sin_cluster.sh", {})

  tags = {
    Name = "proxy-zona2"
  }

  depends_on = [
    aws_vpc.main,
    aws_subnet.public2,
    aws_security_group.sg_proxy,
    aws_key_pair.ssh_key
  ]
}


# # Servidores SGBD en Zona 1
# # Principal
# resource "aws_instance" "sgbd-principal_zona1" {
#   ami                    = "ami-04b4f1a9cf54c11d0"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private1.id
#   key_name               = aws_key_pair.ssh_key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_mysql.id]
#   private_ip             = "10.0.3.10"

#   # User data con el script de configuración
#   user_data = base64encode(templatefile("${path.module}/SCRIPTS-AUTOMATIZACION/SGBD/creacion_y_configuracion_BDs-ZONA1.sh", {
#     role           = "primary",
#     primary_ip     = "10.0.3.10",
#     secondary_ip   = "10.0.3.11",
#     db_user        = "admin",
#     db_password    = "Admin123",
#     db_name        = "prosody",
#     repl_user      = "replica_user",
#     repl_password  = "Admin123",
#     ssh_key_name   = aws_key_pair.ssh_key.key_name,
#     private_key    = tls_private_key.ssh_key.private_key_pem  # Clave privada (nombre corregido)
#   }))

#   tags = {
#     Name = "sgbd-principal_zona1"
#   }

#   depends_on = [
#     aws_vpc.main,
#     aws_subnet.private1,
#     aws_security_group.sg_mysql,
#     aws_key_pair.ssh_key
#   ]
# }

# # Secundario
# resource "aws_instance" "sgbd-secundario_zona1" {
#   ami                    = "ami-04b4f1a9cf54c11d0"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private1.id
#   key_name               = aws_key_pair.ssh_key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_mysql.id]
#   private_ip             = "10.0.3.11"

#   # User Data con variables para el script
#   user_data = base64encode(templatefile("${path.module}/SCRIPTS-AUTOMATIZACION/SGBD/creacion_y_configuracion_BDs-ZONA1.sh", {
#     role           = "secondary",
#     primary_ip     = "10.0.3.10",
#     secondary_ip   = "10.0.3.11",
#     db_user        = "admin",
#     db_password    = "Admin123",
#     db_name        = "prosody",
#     repl_user      = "replica_user",
#     repl_password  = "Admin123",
#     ssh_key_name   = aws_key_pair.ssh_key.key_name,
#     private_key    = tls_private_key.ssh_key.private_key_pem  
#   }))

#   tags = {
#     Name = "sgbd-secundario_zona1"
#   }

#   depends_on = [
#     aws_vpc.main,
#     aws_subnet.private1,
#     aws_security_group.sg_mysql,
#     aws_key_pair.ssh_key
#   ]
# }

# ============================
#  Clusteres y RDS
# ============================

# Instancia Mensajería 1 en Zona 1
resource "aws_instance" "mensajeria_1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private1.id  # Subred privada en Zona 1
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_mensajeria.id]
  private_ip             = "10.0.3.20"  # IP privada fija

  # User Data para cargar el script.sh (comentado de momento)
  # user_data = file("script.sh")

  tags = {
    Name = "mensajeria-1"
  }

  depends_on = [
    aws_vpc.main,
    aws_subnet.private1,
    aws_security_group.sg_mensajeria,
    aws_key_pair.ssh_key
  ]
}

#################################                              
# DESCOMENTAR / ARREGLAR CLUSTER#                             
#                               #
#################################
# # Instancia Mensajería 2 en Zona 1
# resource "aws_instance" "mensajeria_2" {
#   ami                    = "ami-04b4f1a9cf54c11d0"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private1.id  # Subred privada en Zona 1
#   key_name               = aws_key_pair.ssh_key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_mensajeria.id]
#   private_ip             = "10.0.3.30"  # IP privada fija

#   # User Data para cargar el script.sh (comentado de momento)
#   # user_data = file("script.sh")

#   tags = {
#     Name = "mensajeria-2"
#   }

#   depends_on = [
#     aws_vpc.main,
#     aws_subnet.private1,
#     aws_security_group.sg_mensajeria,
#     aws_key_pair.ssh_key
#   ]
# }

##################################                              
# DESCOMENTAR / RDS CUANDO SE USE#                             
#                                #
##################################

# #APARTADO RDS
# # Grupo de subredes para RDS 
# resource "aws_db_subnet_group" "cms_subnet_group" {
#   name       = "cms-db-subnet-group"
#   subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]  # Subnets en 2 AZs

#   tags = {
#     Name = "cms-db-subnet-group"
#   }
# }

# # Instancia RDS - para CMS
# resource "aws_db_instance" "cms_database" {
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   instance_class       = "db.t3.medium"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   username             = "admin"
#   password             = "Admin123"
#   db_name              = "wordpress_db"
#   publicly_accessible  = false
#   multi_az             = false
#   availability_zone    = "us-east-1b"  
#   db_subnet_group_name = aws_db_subnet_group.cms_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.sg_mysql.id]

#   skip_final_snapshot  = true  # PRUEBAS LUEGO ELIMINAR
#   tags = {
#     Name = "wordpress_db"
#   }
#   # identificador a la instancia de la base de datos
#   identifier = "cms-database" 

#   depends_on = [aws_db_subnet_group.cms_subnet_group]
# }
# Cluster de CMS (2 instancias en Zona 2)
resource "aws_instance" "cms_cluster_1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private2.id
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_cms.id]
  private_ip             = "10.0.4.10"  # IP privada fija

  # User Data para cargar el script.sh
  user_data = base64encode(templatefile("${path.module}/SCRIPTS-AUTOMATIZACION/CMS/CMS_SIN_TLS.sh", {
    db_name   = "Admin123",
    db_user   = "admin",
    db_pass   = "_Admin123",
    db_host   = "10.0.4.10",
    db_prefix = "wp_",
    site_url  = "http://10.0.4.100",
    site_title = "PRUEBA_SITIO",
    admin_user = "admin",
    admin_password = "Admin123",
    admin_email = "retoequipo5@gmail.com"
  }))

  tags = {
    Name = "cms-cluster-1"
  }

  depends_on = [
    aws_vpc.main,
    aws_subnet.private2,
    aws_security_group.sg_cms,
    aws_key_pair.ssh_key
  ]
}

#################################                              
# DESCOMENTAR / ARREGLAR CLUSTER#                             
#                               #
#################################

# resource "aws_instance" "cms_cluster_2" {
#   ami                    = "ami-04b4f1a9cf54c11d0"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private2.id
#   key_name               = aws_key_pair.ssh_key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_cms.id]
#   private_ip             = "10.0.4.11"  # IP privada fija

#   # User Data para cargar el script.sh (comentado de momento)
#   # user_data = file("script.sh")

#   tags = {
#     Name = "cms-cluster-2"
#   }

#   depends_on = [
#     aws_vpc.main,
#     aws_subnet.private2,
#     aws_security_group.sg_cms,
#     aws_key_pair.ssh_key
#   ]
# }

# # Jitsi - para videollamadas
# resource "aws_instance" "jitsi_cluster1" {
#   ami                    = "ami-04b4f1a9cf54c11d0"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private1.id  
#   key_name               = aws_key_pair.ssh_key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_jitsi.id]
#   private_ip             = "10.0.3.12"  # IP fija para la primer instancia

#   # User Data para cargar el script.sh (comentado de momento)
#   # user_data = file("script.sh")

#   tags = {
#     Name = "jitsi-zona1"
#   }

#   depends_on = [
#     aws_vpc.main,
#     aws_subnet.private1,
#     aws_security_group.sg_jitsi,
#     aws_key_pair.ssh_key
#   ]
# }