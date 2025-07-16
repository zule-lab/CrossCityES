# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille & Isabella Richmond



# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs',
               #controller = crew_controller_local(workers = 10),
               seed = 666)


# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()


# Variables ---------------------------------------------------------------
#getOption('timeout')
#options(timeout=2000)


# Data --------------------------------------------------------------------
# NOTE: need to create large/ directories if cloning repository 
# example: dir.create(file.path('large', 'neighbourhoods'))
tar_source('input/link-values.R')


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets" lists above
tar_source('scripts')
lapply(grep('targets', ls(), value = TRUE), get)


# TODO: 
# - RF modelling
# - wrap facet labels 
# - add air pollution to report 
# - check air pollution values in data report
# - make figures 
