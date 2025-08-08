# renv
source("renv/activate.R")


# timeout
options(timeout=5000)

# packages
#source('packages.R')

# conflicted
conflicted::conflict_prefer_all('dplyr', quiet = T)
conflicted::conflict_prefer_all('base', 'bit64', quiet = T)
conflicted::conflicts_prefer(base::`%in%`)
conflicted::conflicts_prefer(dplyr::rename)
library(conflicted)
