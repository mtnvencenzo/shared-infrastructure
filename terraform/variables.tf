
variable "domain" {
  type = string
  description = "Domain name. Use only lowercase letters and numbers"
  default = "shared"
}

variable "environment" {
  type    = string
  description = "Environment name, e.g. 'dev' or 'stage' or 'prod'"
  default = "glo"
}

variable "location" {
  type    = string
  description = "Azure region where to create resources."
  default = "East US"
}

variable "region" {
  type	= string
  default = "eus"
}

variable "sub" {
  type    = string
  description = "Subscription short identitifer to be used in resource naming"
  default = "vec"
}

variable "sequence" {
  type    = string
  description = "The sequence number of the resource typically starting with 001"
  default = "001"
}

variable "data_location" {
  type    = string
  description = "The location of the data center"
  default = "United States"
}

variable "containers_subnet_address_prefixes" {
  type = list(string)
  description = "The address space for the containers app environment"
  default = ["10.1.0.0/18"] # Total IPs: 16,384  Range: 10.1.0.0 - 10.1.63.255
}