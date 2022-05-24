# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille



# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')


# Data --------------------------------------------------------------------
hal_tree_spcode_path <- file.path('input', 'hal_tree_spcode.csv') # extracted from tree data metadata accessible from http://hrm.maps.arcgis.com/sharing/rest/content/items/87d562e852a44e64ae268609e2cdc0d2/data

hal_tree_dbhcode_path <- file.path('input', 'hal_tree_dbhcode.csv') #  9 categories, matched with dataset viewed in ARCGIS Viewer from https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d

mon_tree_hoodcode_path <- file.path('input', 'mon_tree_hoodcode.csv') #  9 categories, matched with dataset viewed in ARCGIS Viewer from https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d

tor_tree_spcode_path <- file.path('input', 'tor_tree_spcode.csv') # Toronto tree species codes (obtained by emailing opendata@toronto.com)

ott_tree_spcode_path <- file.path('input', 'ott_tree_spcode.csv') # Ottawa tree species codes (obtained by emailing City of Ottawa)

# Variables ---------------------------------------------------------------
getOption('timeout')
options(timeout=600)

# Scripts -----------------------------------------------------------------
source(file.path('scripts', 'data-download.R'))

# Targets: all ------------------------------------------------------------
# Automatically grab all the "data" lists above
lapply(grep('data', ls(), value = TRUE), get)
