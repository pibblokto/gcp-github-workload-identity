resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = local.pool_config.pool_id
  display_name              = local.pool_config.pool_display_name
  description               = local.pool_config.pool_description
}
resource "google_iam_workload_identity_pool_provider" "global" {
  count                              = local.providers_config.create_global_provider ? 1 : 0
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = local.providers_config.global_provider_id
  display_name                       = "GitHub Actions Global Provider"
  description                        = "Global provider for GitHub Actions tokens for organization ${local.providers_config.github_org}"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner == '${local.providers_config.github_org}'"
}
resource "google_iam_workload_identity_pool_provider" "per_repository" {
  for_each                           = local.providers_config.create_global_provider ? {} : local.providers_config.repositories
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = each.key
  display_name                       = "Repo - ${each.key}"
  description                        = "Provider for GitHub Actions tokens for repository ${local.providers_config.github_org}/${each.key}"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == '${local.providers_config.github_org}/${each.key}'"
}
resource "random_string" "global_sa_sufix" {
  count   = local.providers_config.create_global_provider && local.providers_config.create_global_provider_sa ? 1 : 0
  length  = 5
  special = false
  upper   = false
  numeric = true
}
resource "google_service_account" "global_sa" {
  count        = local.providers_config.create_global_provider && local.providers_config.create_global_provider_sa ? 1 : 0
  account_id   = "global-provider-sa-${random_string.global_sa_sufix[0].result}"
  display_name = "Service account for ${local.providers_config.github_org} organization"
}
resource "google_service_account" "repo_sa" {
  for_each = local.providers_config.repositories

  account_id   = each.value
  display_name = "Service account for repository ${each.key}"
}
resource "google_service_account_iam_member" "global_sa_binding" {
  count = local.providers_config.create_global_provider ? 1 : 0

  service_account_id = local.providers_config.create_global_provider_sa ? google_service_account.global_sa[0].name : local.providers_config.global_provider_sa
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/${local.pool_config.pool_id}/attribute.repository_owner/${local.providers_config.github_org}"
}
resource "google_service_account_iam_member" "global_sa_token_creator_binding" {
  count = local.providers_config.create_global_provider ? 1 : 0

  service_account_id = local.providers_config.create_global_provider_sa ? google_service_account.global_sa[0].name : local.providers_config.global_provider_sa
  role               = "roles/iam.serviceAccountTokenCreator"

  member = "principalSet://iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/${local.pool_config.pool_id}/attribute.repository_owner/${local.providers_config.github_org}"
}
resource "google_service_account_iam_member" "repo_sa_binding" {
  for_each           = google_service_account.repo_sa
  service_account_id = each.value.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/${local.pool_config.pool_id}/attribute.repository/${local.providers_config.github_org}/${each.key}"
}
resource "google_service_account_iam_member" "repo_sa_token_creator_binding" {
  for_each           = google_service_account.repo_sa
  service_account_id = each.value.name
  role               = "roles/iam.serviceAccountTokenCreator"

  member =  "principalSet://iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/${local.pool_config.pool_id}/attribute.repository/${local.providers_config.github_org}/${each.key}"

}
