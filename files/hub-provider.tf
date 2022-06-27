provider "aws" {
  alias   = "keenobi_hub"
  region  = "eu-west-3"
  profile = "keenobi-hub"
  default_tags {
    tags = {
      createdby = "terraform"
    }
  }
}
