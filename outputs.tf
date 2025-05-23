output "repository_name" {
  value = github_repository.repo.name
}

output "repository_url" {
  value = github_repository.repo.html_url
}