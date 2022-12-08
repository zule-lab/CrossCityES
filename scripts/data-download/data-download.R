targets_data_download <- c(
  


  # Download Links: National ------------------------------------------------
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_bounds
  ),
  


  # Download Links: Census --------------------------------------------------
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_census
  ),
  

  # Download Links: Neighbourhoods ------------------------------------------
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_hood
  ),

  # Download Links: Parks ---------------------------------------------------
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_parks
  ),

  # Download Links: Trees ---------------------------------------------------
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_trees
  ),

  # Download Links: DEMs ----------------------------------------------------
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_dems
  ),
  

  # Microsoft Building Footprints -------------------------------------------
  # TODO: SWITCH TO GEE
  tar_target(
    prov_list,
    c("Alberta", "NovaScotia", "Quebec", "Ontario", "BritishColumbia", "Manitoba")
  ),
  
  tar_target(
    build_raw,
    for (i in 1:length(prov_list)){
      build_url <- paste0("https://usbuildingdata.blob.core.windows.net/canadian-buildings-v2/", prov_list, ".zip")
      build_dest <- paste0("large/national/", prov_list, "_building_density.zip")
      build_output <- paste0("large/national/", prov_list, "_building_density")
      download.file(build_url[i], build_dest[i], mode="wb")
    }
  ),
  
  
  # Supplementary Files -----------------------------------------------------
  
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