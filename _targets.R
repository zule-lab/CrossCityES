# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille



# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')


# Data --------------------------------------------------------------------
# extracted from tree data metadata accessible from 
# http://hrm.maps.arcgis.com/sharing/rest/content/items/87d562e852a44e64ae268609e2cdc0d2/data
hal_tree_spcode_path <- file.path('input', 'hal_tree_spcode.csv')

# 9 categories, matched with dataset viewed in ARCGIS Viewer from 
# https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
hal_tree_dbhcode_path <- file.path('input', 'hal_tree_dbhcode.csv')

# 9 categories, matched with dataset viewed in ARCGIS Viewer from 
# https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
mon_tree_hoodcode_path <- file.path('input', 'mon_tree_hoodcode.csv')

# Toronto tree species codes (obtained by emailing opendata@toronto.com)
tor_tree_spcode_path <- file.path('input', 'tor_tree_spcode.csv')

# Ottawa tree species codes (obtained by emailing City of Ottawa)
ott_tree_spcode_path <- file.path('input', 'ott_tree_spcode.csv') 


# Variables ---------------------------------------------------------------
getOption('timeout')
options(timeout=600)


# Scripts -----------------------------------------------------------------
tar_source('scripts')


# Targets: all ------------------------------------------------------------
# Automatically grab all the "data" lists above
lapply(grep('targets', ls(), value = TRUE), get)
