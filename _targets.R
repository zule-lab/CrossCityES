# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille & Isabella Richmond



# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs',
               #controller = crew_controller_local(workers = 13),
               packages = c('targets', 'tarchetypes', 'crew', 'qs2', 'quarto', 'renv', 'conflicted', 'downloader', 'readr',
                            'sf', 'geojsonio', 'stars', 'osmdata', 'rnaturalearth', 'ggrepel', 'DALEXtra', 'xfun',
                            'tidyr', 'stringr', 'tibble', 'units', 'anytime', 'FactoMineR', 'factoextra', 'ggplot2',
                            'MetBrewer', 'visNetwork', 'vegan', 'mice', 'cluster', 'ranger', 'tidymodels', 'themis', 'vip', 
                            'bit64', 'base', 'plyr', 'data.table', 'dplyr'),
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

