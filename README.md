# Terragrunt demonstration

This is a simple example of using Terragrunt. We have two regions to set up that should be identical, save a small detail
that differs between them. In the real world, this difference could either be difference between environments (e.g. prod vs UAT) or a difference between regions of a multi-region setup.

In this case, while `eu-west-1/two` will create `eu-west-1/two/output.txt` containing a random string generated from `eu-west-1/one`, `eu-west-2/two` will create `eu-west-2/two/output.txt` that contains `overridden` (which is set by a `terraform.tfvars` file).

## Cautions to remember
* Avoid using the `terraform_remote_state` data source so inter-module dependencies are explicit rather than implicit
* Use `data` sources carefully to avoid accidentally picking resources managed by other modules
* `run-all plan` will fail if a module uses the output from another module as an input but the other module has yet to be applied. The solution to this is either:
  * Only change one module at a time
  * Define `mock_outputs` on the dependency

## Complete CI pipeline once the environment is created

> FWIW, we very rarely use `apply-all` for anything other than the initial deployment of an entire environment. After that, once code is running in prod, we always deploy one module at a time, usually via CI, with PR and `plan` reviews.

https://github.com/gruntwork-io/terragrunt/issues/486#issuecomment-396410107

1. PR raised
   * Require branch is up-to-date with target
   * `terragrunt hclfmt`
   * Require only a single module has been changed
     * What should happen if multiple modules affected, such as `root.hcl`?
   * `terragrunt plan` which is outputted to a comment
   * Highlight downstream modules which might be affected?
2. PR merged
3. Changes applied
4. Run some sort of smoke test against the environment, such as calling `kubectl get cm -n kube-system aws-auth`
   * The smoke test would need to be versioned alongside the Terraform/OpenTofu module, as changes to the module would affect the smoke test as well

## Questions to consider
* How should changes be promoted between environments? How would drift between environments be identified?
  * Per-environment values could be placed into `terraform.tfvars` files, thus aiming to leave `terragrunt.hcl` files identical between environments

## Cleaning up
Run this command to clean up all generated files:

```shell
find . -name .terragrunt-cache -prune -o -name .terraform.lock.hcl -prune -o -name terraform.tfstate -prune -o -name output.txt -prune | xargs rm -rf
```
