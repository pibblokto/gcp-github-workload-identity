locals {
    project_id     = var.project_id
    project_number = data.google_project.this.number
    region         = var.region
    pool_config = {
        pool_id           = var.pool_id
        pool_display_name = var.pool_display_name
        pool_description  = var.pool_description
    }
    providers_config = {
        create_global_provider    = var.create_global_provider
        create_global_provider_sa = var.create_global_provider_sa
        global_provider_id        = var.global_provider_id
        github_org                = var.github_org
        repositories              = var.repositories
        global_provider_sa        = var.global_provider_sa

    }
}
data "google_project" "this" {
    project_id = local.project_id
}
