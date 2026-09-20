variable "vpc_config" {
  description = "Configuration for the VPC."

  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The specified VPC CIDR block is invalid."
  }
}

variable "subnet_config" {
  description = "Configuration for the subnets."

  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])

    error_message = "At least one subnet has an invalid CIDR block."
  }
}