## Define ONCE FOR ALL your credentials ----

rcompendium::set_credentials(given = "rebecca", family = "fisher", 
                             email = "r.fisher@aims.gov.au", 
                             orcid = "0000-0001-5148-6731", protocol = "https")


usethis::use_git_config(
  user.name  = "Rebecca Fisher",
  user.email = "r.fisher@aims.gov.au"
)

## CREATE A NEW EMPTY RSTUDIO PROJECT ----


## Create an R package structure ----

rcompendium::new_package()


## Then... 
## ... edit metadata in DESCRIPTION, CITATION, README.Rmd, etc.
## ... implement and document R functions in R/


## Update functions documentation and NAMESPACE ----

devtools::document()


## Update list of dependencies in DESCRIPTION ----

rcompendium::add_dependencies()


## Check package ----

devtools::check()


## Example: use of an add_*() function ...
## ... update 'Number of Dependencies Badge' in README.Rmd ----

rcompendium::add_dependencies_badge()