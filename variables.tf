variable "project_id" {
  description = "GCP Project ID."
  type        = string
}
variable "region" {
  description = "GCP Region."
  type        = string
  default     = "us-central1"
}
variable "create_global_provider" {
  description = "If true, create a single global workload identity provider for the whole organization. Otherwise, create one per repository."
  type        = bool
  default     = false
}
variable "github_org" {
  description = "The GitHub organization name (e.g. \"my-org\")."
  type        = string
  default     = ""
}
variable "repositories" {
  description = "Mapping of repository names to service account IDs to be created for that repository."
  type        = map(string)
  default     = {}
}
variable "pool_id" {
  description = "ID to assign to the Workload Identity Pool."
  type        = string
  default     = ""
}
variable "pool_display_name" {
  description = "Display name for the Workload Identity Pool."
  type        = string
  default     = ""
}
variable "pool_description" {
  description = "Description for the Workload Identity Pool."
  type        = string
  default     = "Workload Identity Pool for GitHub Actions"
}
variable "global_provider_id" {
  description = "The provider id for the global workload identity provider. Used if \"global_provider\" is true"
  type        = string
  default     = "github-actions-global"
}
variable "create_global_provider_sa" {
  description = "If true, create service accout for global workload identity provider for the whole organization. If set to false, then global_provider_sa has to be specified"
  type        = bool
  default     = false
}
variable "global_provider_sa" {
  description = "Fully qualified identifier of service account that can assume global provider."
  type        = string
  default     = ""
}
