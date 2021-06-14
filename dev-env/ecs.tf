data "aws_caller_identity" "current" {}

module "dev-ecs" {
  source         = "../modules/ecs-cluster"
  VPC_ID         = "vpc-id"
  CLUSTER_NAME   = "dev-ecs"
  INSTANCE_TYPE  = "t2.small"
  SSH_KEY_NAME   = "devkeypairname"
  VPC_SUBNETS    = "subnetId-1,subnetId-2"
  ENABLE_SSH     = true
  SSH_SG         = "dev-ssh-sg"
  LOG_GROUP      = "dev-log-group"
  AWS_ACCOUNT_ID = "1234567890"
  AWS_REGION     = "eu-west-1"
}

module "dev-service" {
  source              = "../modules/ecs-service"
  VPC_ID              = "vpc-id"
  APPLICATION_NAME    = "dev-service"
  APPLICATION_PORT    = "8080"
  APPLICATION_VERSION = "latest"
  CLUSTER_ARN         = module.dev-ecs.cluster_arn
  SERVICE_ROLE_ARN    = module.dev-ecs.service_role_arn
  AWS_REGION          = "eu-west-1"
  HEALTHCHECK_MATCHER = "200"
  CPU_RESERVATION     = "1024"
  MEMORY_RESERVATION  = "1024"
  LOG_GROUP           = "dev-log-group"
  DESIRED_COUNT       = "2"
}

module "dev-alb" {
  source             = "../modules/alb"
  VPC_ID             = "vpc-id"
  ALB_NAME           = "dev-alb"
  VPC_SUBNETS        = "subnetId-1,subnetId-2"
  DEFAULT_TARGET_ARN = module.dev-service.target_group_arn
  DOMAIN             = "*.dev-ecs.com"
  INTERNAL           = false
  ECS_SG             = module.dev-ecs.cluster_sg
}

module "dev-alb-rule" {
  source           = "../modules/alb-rule"
  LISTENER_ARN     = module.dev-alb.http_listener_arn
  PRIORITY         = 100
  TARGET_GROUP_ARN = module.dev-service.target_group_arn
  # CONDITION_FIELD  = "host-header"
  # CONDITION_VALUES = ["subdomain.dev-ecs.com"]
}
