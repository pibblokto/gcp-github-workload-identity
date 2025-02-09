output "repository_sa_wif_mappings" {
  description = "A list of objects for per-repository service accounts, including the repository name, workload identity provider, and service account email."
  value = [
    for repo, sa in google_service_account.repo_sa : {
      repository                 = repo
      workload_identity_provider = google_iam_workload_identity_pool_provider.per_repository[repo].name
      service_account            = sa.email
      name                       = sa.name
    }
  ]
}
output "global_provider_name" {
    description = "Global workload identity provider name."
    value       = local.providers_config.create_global_provider ? google_iam_workload_identity_pool_provider.global[0].name : null
}
output "global_provider_sa" {
    description = "Global workload identity service account email."
    value       = local.providers_config.create_global_provider_sa ? google_service_account.global_sa[0].email : local.providers_config.global_provider_sa
}
