resource "github_repository" "repo" {
  name               = var.repository_name
  description        = var.repository_description
  visibility         = var.visibility
  auto_init          = true
#   license_template   = "mit"
#   gitignore_template = "Terraform"
  has_wiki           = false
  has_issues         = true
  has_projects       = false
  has_discussions    = false
}

resource "github_branch" "main" {
  repository = github_repository.repo.name
  branch     = "main"
}

# resource "github_branch_default" "default" {
#   repository = github_repository.repo.name
#   branch     = github_branch.main.branch
# }

# Create workflows directory first

# resource "github_repository_file" "workflows_dev_deploy" {
#   repository          = github_repository.repo.name
#   branch              = github_branch.main.branch
#   file                = ".github/workflows/dev_deploy.yaml"
#   content             = file("${path.module}/data/.github/workflows/dev_deploy.yaml")
#   commit_message      = "Add dev deployment workflow"
#   overwrite_on_create = true
# }

# resource "github_repository_file" "workflows_pr" {
#   repository          = github_repository.repo.name
#   branch              = github_branch.main.branch
#   file                = ".github/workflows/pr_workflow.yaml"
#   content             = file("${path.module}/data/.github/workflows/pr_workflow.yaml")
#   commit_message      = "Add PR workflow"
#   overwrite_on_create = true
# }

# resource "github_repository_file" "workflows_tf_deployment" {
#   repository          = github_repository.repo.name
#   branch              = github_branch_default.default.branch
#   file                = ".github/workflows/tf_deployment_template.yaml"
#   content             = file("${path.module}/data/.github/workflows/tf_deployment_template.yaml")
#   commit_message      = "Add Terraform deployment workflow template"
#   overwrite_on_create = true
# }

resource "github_repository_file" "infra_files" {
  for_each            = toset(["README.md", "main.tf", "outputs.tf", "providers.tf", "variables.tf"])
  repository          = github_repository.repo.name
  branch              = github_branch.main.branch
  file                = "infra/${each.key}"
  content             = ""
  commit_message      = "Add infra ${each.key} placeholder"
  overwrite_on_create = true
}

# Create deployment environments
resource "github_repository_environment" "environments" {
  for_each    = toset(["dev", "test", "prod"])
  environment = each.key
  repository  = github_repository.repo.name
}

# Add secrets to each environment
resource "github_actions_environment_secret" "aws_role" {
  for_each        = toset(["dev", "test", "prod"])
  repository      = github_repository.repo.name
  environment     = each.key
  secret_name     = "AWS_ROLE_TO_ASSUME"
  plaintext_value = ""
  depends_on      = [github_repository_environment.environments]
}

resource "github_actions_environment_secret" "aws_region" {
  for_each        = toset(["dev", "test", "prod"])
  repository      = github_repository.repo.name
  environment     = each.key
  secret_name     = "AWS_REGION"
  plaintext_value = ""
  depends_on      = [github_repository_environment.environments]
}

resource "github_actions_environment_secret" "s3_bucket_name" {
  for_each        = toset(["dev", "test", "prod"])
  repository      = github_repository.repo.name
  environment     = each.key
  secret_name     = "S3_BUCKET_NAME"
  plaintext_value = ""
  depends_on      = [github_repository_environment.environments]
}

resource "github_actions_environment_secret" "s3_key_prefix" {
  for_each        = toset(["dev", "test", "prod"])
  repository      = github_repository.repo.name
  environment     = each.key
  secret_name     = "S3_KEY_PREFIX"
  plaintext_value = ""
  depends_on      = [github_repository_environment.environments]
}
