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
options(timeout=1200)



# Data --------------------------------------------------------------------
tar_source('input/link-values.R')
# NOTE: need to create large/ directories if cloning repository 
# example: dir.create(file.path('large', 'neighbourhoods'))


# Scripts -----------------------------------------------------------------
# tar_source('scripts')
tar_source('scripts')


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets" lists above

# lapply(grep('targets', ls(), value = TRUE), get)

c(targets_prepare_boundaries, targets_prepare_neighbourhoods, targets_prepare_census, 
  targets_prepare_supp, targets_prepare_trees, targets_prepare_scales, targets_prepare_buildings,
  targets_prepare_ee, targets_building_density, targets_road_class, targets_census, targets_tree_size, 
  targets_tree_density, targets_tree_richness)

# TODO: 
# - update join
# - update quarto doc
# - add functional diversity of trees
