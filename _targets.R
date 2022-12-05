# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille



# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')



# Variables ---------------------------------------------------------------
getOption('timeout')
options(timeout=600)



# Scripts -----------------------------------------------------------------
tar_source('scripts')



# Targets: all ------------------------------------------------------------
# Automatically grab all the "data" lists above

#lapply(grep('targets', ls(), value = TRUE), get)

targets_data_download