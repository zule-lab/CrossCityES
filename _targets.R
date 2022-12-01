# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille



# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)



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
source(file.path('scripts', 'data-download.R'))
source(file.path('scripts', 'neighbourhood-data-cleanup.R'))
source(file.path('scripts', 'road-data-cleanup.R'))
source(file.path('scripts', 'temperature-data-cleanup.R'))
source(file.path('scripts', 'pollution-data-cleanup.R'))
source(file.path('scripts', 'ndvi-ndbi-data-cleanup.R'))
source(file.path('scripts', 'census-data-cleanup.R'))
source(file.path('scripts', 'dsm-data-cleanup.R'))
source(file.path('scripts', 'building-data-cleanup.R'))
source(file.path('scripts', 'calgary-data-cleanup.R'))
source(file.path('scripts', 'halifax-data-cleanup.R'))
source(file.path('scripts', 'montreal-data-cleanup.R'))
source(file.path('scripts', 'ottawa-data-cleanup.R'))
source(file.path('scripts', 'toronto-data-cleanup.R'))
source(file.path('scripts', 'vancouver-data-cleanup.R'))
source(file.path('scripts', 'winnipeg-data-cleanup.R'))
source(file.path('scripts', 'all-tree-data.R'))
source(file.path('scripts', 'census-data-city-neighbourhood.R'))
source(file.path('scripts', 'building-data-city-neighbourhood-road.R'))
source(file.path('scripts', 'height-data-city-neighbourhood-road.R'))
source(file.path('scripts', 'roadclass-data-city-neighbourhood.R'))
source(file.path('scripts', 'functional-data-city-neighbourhood-road.R'))
source(file.path('scripts', 'richness-data-city-neighbourhood-road.R'))
source(file.path('scripts', 'treedensity-data-city-neighbourhood-road.R'))
source(file.path('scripts', 'treesize-data-city-neighbourhood-road.R'))
source(file.path('scripts', 'full-data-sets.R'))
source(file.path('scripts', 'raw-data-viz.R'))


# Targets: all ------------------------------------------------------------
# Automatically grab all the "data" lists above
lapply(grep('data', ls(), value = TRUE), get)
