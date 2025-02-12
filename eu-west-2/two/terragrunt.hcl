include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/source/two"
}

dependency "one" {
  config_path = "../one"
}

inputs = {
  input = dependency.one.outputs.output
  dir = "${get_terragrunt_dir()}"
}
