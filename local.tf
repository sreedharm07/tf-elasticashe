locals {
  tags= merge(var.tags,{tfmodule="elasticache"},{env=var.env} )
  name-pre= "${var.env}-cache"
}