variable "LISTENER_ARN" {}

variable "PRIORITY" {}

variable "TARGET_GROUP_ARN" {}

variable "CONDITION_FIELD" {}

variable "CONDITION_VALUES" {
  type = list(string)
}
