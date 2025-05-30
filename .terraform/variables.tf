
variable "domain" {
  type        = string
  description = "Domain name. Use only lowercase letters and numbers"
  default     = "shared"
}

variable "shortdomain" {
  type        = string
  description = "Short domain name. Use only lowercase letters and numbers"
  default     = "shared"
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. 'dev' or 'stage' or 'prod'"
  default     = "glo"
}

variable "location" {
  type        = string
  description = "Azure region where to create resources."
  default     = "East US"
}

variable "region" {
  type    = string
  default = "eus"
}

variable "sub" {
  type        = string
  description = "Subscription short identitifer to be used in resource naming"
  default     = "vec"
}

variable "sequence" {
  type        = string
  description = "The sequence number of the resource typically starting with 001"
  default     = "001"
}

variable "short_sequence" {
  type        = string
  description = "The short sequence number of the resource typically starting with 1"
  default     = "1"
}

variable "data_location" {
  type        = string
  description = "The location of the data center"
  default     = "United States"
}

variable "containers_subnet_address_prefixes" {
  type        = list(string)
  description = "The address space for the containers app environment"
  default     = ["10.1.0.0/18"] # Total IPs: 16,384  Range: 10.1.0.0 - 10.1.63.255
}

variable "log_analytics_workspace_tables_for_reduced_retention_period" {
  type        = list(string)
  description = "The names of the log analytics tables that should have reduced retention periods"
  default = [
    "AppAvailabilityResults",
    "AppBrowserTimings",
    "AppDependencies",
    "AppEvents",
    "AppExceptions",
    "AppMetrics",
    "AppPageViews",
    "AppPerformanceCounters",
    "AppRequests",
    "AppTraces",
    "AppSystemEvents"
  ]
}

variable "log_analytics_workspace_tables_reduced_retention_period" {
  type        = number
  description = "The number of days to use for the retention period"
  default     = 30 # cant be less than 90 (which is the default so this is kind of not needed)
}