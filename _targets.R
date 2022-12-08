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



# rgee --------------------------------------------------------------------
#ee_check()
#ee_Initialize()



# Variables ---------------------------------------------------------------
getOption('timeout')
options(timeout=600)



# Data --------------------------------------------------------------------
tar_source('input/link-values.R')
# NOTE: need to create large/ directories if cloning repository 
# example: dir.create(file.path('large', 'neighbourhoods'))


# Scripts -----------------------------------------------------------------
# tar_source('scripts')
tar_source('scripts/prepare-neighbourhoods/prepare-neighbourhoods.R')


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets" lists above

#lapply(grep('targets', ls(), value = TRUE), get)

c(targets_prepare_neighbourhoods)
