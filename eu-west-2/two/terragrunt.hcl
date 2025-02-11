include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/source/two"
}

dependency "one" {
  config_path = "../one"
}

inputs = {
  input = dependency.one.outputs.output
  dir = "${get_terragrunt_dir()}"
}
