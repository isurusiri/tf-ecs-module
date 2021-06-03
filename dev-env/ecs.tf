data "aws_caller_identity" "current" {}

module "dev-ecs" {
    source = "../modules/ecs-cluster"
}

module "dev-service" {
    source = "../modules/ecs-service"
}