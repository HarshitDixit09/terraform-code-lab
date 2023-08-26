terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "github"{
  token = "enter token"
}
resource "github_repository" "examplerepo" {
    name = "terraformtest"
    description = "to test terraform"
    visibility = "public" 
}
