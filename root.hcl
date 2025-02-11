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

# Demonstrate both generating a file as well as picking the region out of the file structure.
# This region could then be used to generate the AWS provider configuration,
# although https://github.com/hashicorp/terraform-provider-aws/issues/27758 is still bubbling away.
locals {
  possible_region = split("/", path_relative_to_include())[0]
  region = local.possible_region == "_global" ? "eu-west-1" : local.possible_region
}

generate "region" {
  path = "__region.tf"
  if_exists = "overwrite_terragrunt"

  contents =<<EOF
# region is ${local.region}
EOF
}
