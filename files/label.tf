# module.label.id is
# "customer", "project", "environment", "name", "attributes"
# if they are defined
# with the separator "-"
# attributes is a list of string (for exemple ["attr1", "attr2"]

# For example:
# id => customer-project-environment-tfrun-attr1-attr2
module "label" {
  source      = "./terraform-aws-commons/modules/label"
  customer    = var.customer
  project     = var.project
  tfrun       = var.tfrun
  globalenv   = var.globalenv
  environment = var.environment
}
# Some module proposes to define properly tag Name but this clean tag is still overridable. In this case, we need a list of tag without Name.
module "label_no_name" {
  source       = "./terraform-aws-commons/modules/label"
  context      = module.label.context
  name_in_tags = false
}
