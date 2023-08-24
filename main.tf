resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.name-pre}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "main" {
  name   = "${local.name-pre}-pg"
  family = var.family
}

resource "aws_security_group" "main" {
  name        =  "${local.name-pre}-sg"
  description = "${local.name-pre}-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags,{Name= "${local.name-pre}-sg"})

  ingress {
    description      = "redis"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.sg-ingress-cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${local.name-pre}-cluster"
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  port                 = var.port
  security_group_ids   = [aws_security_group.main.id]
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  parameter_group_name = aws_elasticache_parameter_group.main.name
}

