remote_state {
  # Use local remote state rather than a 'real' one for simplicity
  backend = "local"

  generate = {
    path      = "__backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${get_parent_terragrunt_dir()}/state/${path_relative_to_include()}/terraform.tfstate"
  }
}
