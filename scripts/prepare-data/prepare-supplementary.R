targets_prepare_supp <- c(
  
  
  # extracted from tree data metadata accessible from 
  # http://hrm.maps.arcgis.com/sharing/rest/content/items/87d562e852a44e64ae268609e2cdc0d2/data
  tar_file_read(
    hal_tree_spcode,
    'input/hal_tree_spcode.csv',
    read.csv(!!.x)
  ),
  
  # 9 categories, matched with dataset viewed in ARCGIS Viewer from 
  # https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
  tar_file_read(
    hal_tree_dbhcode,
    'input/hal_tree_dbhcode.csv',
    read.csv(!!.x, row.names = NULL)
  ),
  
  # 9 categories, matched with dataset viewed in ARCGIS Viewer from 
  # https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
  tar_file_read(
    mon_tree_hoodcode,
    'input/mon_tree_hoodcode.csv',
    read.csv(!!.x, row.names = NULL)
  ),
  
  # Toronto tree species codes (obtained by emailing opendata@toronto.com)
  tar_file_read(
    tor_tree_spcode,
    'input/tor_tree_spcode.csv',
    read.csv(!!.x)
  ),
  
  # Ottawa tree species codes (obtained by emailing City of Ottawa)
  tar_file_read(
    ott_tree_spcode,
    'input/ott_tree_spcode.csv', 
    read.csv(!!.x)
  )
  
)