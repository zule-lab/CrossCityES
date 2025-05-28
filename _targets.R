# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille & Isabella Richmond



# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')



# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()


# Variables ---------------------------------------------------------------
getOption('timeout')
options(timeout=2000)



# Data --------------------------------------------------------------------
tar_source('input/link-values.R')
# NOTE: need to create large/ directories if cloning repository 
# example: dir.create(file.path('large', 'neighbourhoods'))


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets" lists above
tar_source('scripts')
lapply(grep('targets', ls(), value = TRUE), get)


# TODO: 
# - RF modelling