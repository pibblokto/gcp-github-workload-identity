## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.global](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_iam_workload_identity_pool_provider.per_repository](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_service_account.global_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.repo_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.global_sa_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.global_sa_token_creator_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.repo_sa_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.repo_sa_token_creator_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [random_string.global_sa_sufix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_global_provider"></a> [create\_global\_provider](#input\_create\_global\_provider) | If true, create a single global workload identity provider for the whole organization. Otherwise, create one per repository. | `bool` | `false` | no |
| <a name="input_create_global_provider_sa"></a> [create\_global\_provider\_sa](#input\_create\_global\_provider\_sa) | If true, create service accout for global workload identity provider for the whole organization. If set to false, then global\_provider\_sa has to be specified | `bool` | `false` | no |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | The GitHub organization name (e.g. "my-org"). | `string` | `""` | no |
| <a name="input_global_provider_id"></a> [global\_provider\_id](#input\_global\_provider\_id) | The provider id for the global workload identity provider. Used if "global\_provider" is true | `string` | `"github-actions-global"` | no |
| <a name="input_global_provider_sa"></a> [global\_provider\_sa](#input\_global\_provider\_sa) | Fully qualified identifier of service account that can assume global provider. | `string` | `""` | no |
| <a name="input_pool_description"></a> [pool\_description](#input\_pool\_description) | Description for the Workload Identity Pool. | `string` | `"Workload Identity Pool for GitHub Actions"` | no |
| <a name="input_pool_display_name"></a> [pool\_display\_name](#input\_pool\_display\_name) | Display name for the Workload Identity Pool. | `string` | `""` | no |
| <a name="input_pool_id"></a> [pool\_id](#input\_pool\_id) | ID to assign to the Workload Identity Pool. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region. | `string` | `"us-central1"` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Mapping of repository names to service account IDs to be created for that repository. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_global_provider_name"></a> [global\_provider\_name](#output\_global\_provider\_name) | Global workload identity provider name. |
| <a name="output_global_provider_sa"></a> [global\_provider\_sa](#output\_global\_provider\_sa) | Global workload identity service account email. |
| <a name="output_repository_sa_wif_mappings"></a> [repository\_sa\_wif\_mappings](#output\_repository\_sa\_wif\_mappings) | A list of objects for per-repository service accounts, including the repository name, workload identity provider, and service account email. |





## Examples

### Example 1: Using a Global Workload Identity Provider
This example sets up a **single global provider** for all GitHub repositories in the organization.

```hcl
module "github_wif_global" {
  source = "./path-to-this-module"

  project_id                = "my-gcp-project"
  github_org                = "my-org"
  create_global_provider    = true
  create_global_provider_sa = true

  pool_id           = "github-wif-pool"
  pool_display_name = "GitHub Actions Pool"
  pool_description  = "Workload Identity Pool for GitHub Actions"
}
```

### Example 2: Using Per-Repository Workload Identity Providers
This example creates a **separate Workload Identity Provider for each repository**.

```hcl
module "github_wif_per_repo" {
  source = "./path-to-this-module"

  project_id             = "my-gcp-project"
  github_org             = "my-org"
  create_global_provider = false

  repositories = {
    "repo-one" = "sa-repo-one"
    "repo-two" = "sa-repo-two"
  }

  pool_id           = "github-wif-pool"
  pool_display_name = "GitHub Actions Pool"
  pool_description  = "Workload Identity Pool for GitHub Actions"
}
```
