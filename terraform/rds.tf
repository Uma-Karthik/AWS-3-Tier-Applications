# RDS SUBNET GROUP

resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.db_az1.id,
    aws_subnet.db_az2.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
    Tier = "Database"
  }
}

# RDS MYSQL DATABASE

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.project_name}-mysql"
    Tier = "Database"
  }
}