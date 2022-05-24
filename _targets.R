# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille



# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')


# Variables ---------------------------------------------------------------


# Scripts -----------------------------------------------------------------
source(file.path('scripts', 'data-download.R'))
source(file.path('scripts', 'neighbourhood-cleanup.R'))
source(file.path('scripts', 'road-cleanup.R'))

# Targets: all ------------------------------------------------------------
# Automatically grab all the "park" lists above
lapply(grep('.R', ls(), value = TRUE), get)