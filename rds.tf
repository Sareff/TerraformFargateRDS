resource "aws_security_group" "sg-rds-task-2" {
  name   = "security-group-rds-task-2"
  vpc_id = aws_vpc.vpc-task-2.id

  ingress {
    security_groups = [aws_security_group.sg-ecs-task-2.id]
    from_port       = 3306
    protocol        = "TCP"
    to_port         = 3306
  }
}

resource "aws_db_subnet_group" "sub-g-rds-task-2" {
  name       = "sub-g-rds-task-2"
  subnet_ids = [aws_subnet.private-a2-task-2.id, aws_subnet.private-b2-task-2.id]
}

resource "aws_db_instance" "master-rds-mysql-task-2" {
  identifier              = "master-rds-mysql"
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "db01"
  username                = "admin"
  password                = "Aa123456"
  availability_zone       = "eu-central-1a"
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "23:29-23:59"
  backup_retention_period = 1
  vpc_security_group_ids  = [aws_security_group.sg-rds-task-2.id]
  db_subnet_group_name    = aws_db_subnet_group.sub-g-rds-task-2.name
  skip_final_snapshot     = true

  provisioner "local-exec" {
    command = "echo \"CREATE TABLE testweb53(recordId VARCHAR(256) DEFAULT NULL)\" | mysql -D db01"
  }
}

resource "aws_db_instance" "replica-rds-mysql-task-2" {
  identifier              = "replica-rds-mysql"
  replicate_source_db     = aws_db_instance.master-rds-mysql-task-2.identifier
  instance_class          = "db.t2.micro"
  name                    = "db01"
  username                = null
  password                = null
  availability_zone       = "eu-central-1b"
  maintenance_window      = "Tue:00:00-Tue:03:00"
  backup_window           = "22:29-22:59"
  backup_retention_period = 1
  vpc_security_group_ids  = [aws_security_group.sg-rds-task-2.id]
  skip_final_snapshot     = true
}